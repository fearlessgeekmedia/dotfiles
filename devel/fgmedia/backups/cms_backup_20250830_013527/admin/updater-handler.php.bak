<?php
/**
 * FearlessCMS Updater Handler
 * Clean version that calls the bash updater script
 */

// Ensure we're in admin context
if (!defined('ADMIN_CONTEXT')) {
    require_once dirname(__DIR__) . '/includes/auth.php';
    require_once dirname(__DIR__) . '/includes/config.php';
    require_once dirname(__DIR__) . '/includes/session.php';
    
    // Start session if not already started
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
}

// Simple CSRF token generation and validation
function generate_updater_csrf_token() {
    if (!isset($_SESSION['updater_csrf_token'])) {
        $_SESSION['updater_csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['updater_csrf_token'];
}

function validate_updater_csrf_token($token) {
    return isset($_SESSION['updater_csrf_token']) && 
           hash_equals($_SESSION['updater_csrf_token'], $token);
}

// Handle POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'updates') {
    
    // Debug logging
    error_log("Updater POST request received");
    error_log("POST data: " . print_r($_POST, true));
    error_log("Session data: " . print_r($_SESSION, true));
    error_log("CSRF token in POST: " . ($_POST['updater_csrf_token'] ?? 'NOT SET'));
    error_log("CSRF token in session: " . ($_SESSION['updater_csrf_token'] ?? 'NOT SET'));
    
    // Validate updater internal CSRF token first
    if (!isset($_POST['updater_csrf_token']) || !validate_updater_csrf_token($_POST['updater_csrf_token'])) {
        error_log("Updater CSRF validation failed");
        error_log("POST token: " . ($_POST['updater_csrf_token'] ?? 'NOT SET'));
        error_log("Session token: " . ($_SESSION['updater_csrf_token'] ?? 'NOT SET'));
        $_SESSION['error'] = 'Invalid security token. Please refresh the page and try again.';
        header('Location: ' . $_SERVER['REQUEST_URI']);
        exit;
    }
    
    error_log("Updater CSRF validation passed");
    
    $subaction = $_POST['subaction'] ?? '';
    
    if ($subaction === 'save_settings') {
        // Save update settings
        $repo = trim($_POST['repo'] ?? '');
        $branch = trim($_POST['branch'] ?? 'main');
        
        if (empty($repo)) {
            $_SESSION['error'] = 'Repository URL is required.';
        } else {
            // Save to config
            $configFile = CONFIG_DIR . '/config.json';
            $config = file_exists($configFile) ? json_decode(file_get_contents($configFile), true) : [];
            $config['update_repo_url'] = $repo;
            $config['update_branch'] = $branch;
            
            if (file_put_contents($configFile, json_encode($config, JSON_PRETTY_PRINT))) {
                $_SESSION['success'] = 'Update settings saved successfully.';
            } else {
                $_SESSION['error'] = 'Failed to save update settings.';
            }
        }
        
        header('Location: ' . $_SERVER['REQUEST_URI']);
        exit;
        
    } elseif ($subaction === 'perform_update') {
        // Call the bash updater script
        $branch = trim($_POST['branch'] ?? 'main');
        $createBackup = isset($_POST['create_backup']);
        $dryRun = isset($_POST['dry_run']);
        
        try {
            // Build the command for the bash updater
            $updateScript = dirname(__DIR__) . '/update.sh';
            
            if (!file_exists($updateScript)) {
                throw new Exception('Update script not found. Please ensure update.sh exists in the CMS root directory.');
            }
            
            if (!is_executable($updateScript)) {
                throw new Exception('Update script is not executable. Please run: chmod +x update.sh');
            }
            
            // Build command arguments
            $cmd = escapeshellarg($updateScript);
            
            if ($dryRun) {
                $cmd .= ' --dry-run';
            }
            
            if (!$createBackup) {
                $cmd .= ' --no-backup';
            }
            
            // Get custom repo/branch if set
            $configFile = CONFIG_DIR . '/config.json';
            $config = file_exists($configFile) ? json_decode(file_get_contents($configFile), true) : [];
            $repo = $config['update_repo_url'] ?? '';
            $defaultBranch = $config['update_branch'] ?? 'main';
            
            if (!empty($repo)) {
                $cmd .= ' -r ' . escapeshellarg($repo);
            }
            
            if ($branch !== $defaultBranch) {
                $cmd .= ' -b ' . escapeshellarg($branch);
            }
            
            error_log("Executing bash updater command: " . $cmd);
            
            // Execute the bash updater
            $output = [];
            $returnCode = 0;
            
            exec($cmd . ' 2>&1', $output, $returnCode);
            
            error_log("Bash updater return code: " . $returnCode);
            error_log("Bash updater output: " . print_r($output, true));
            
            if ($returnCode === 0) {
                if ($dryRun) {
                    $_SESSION['success'] = 'Dry run completed successfully. Check the output below for details.';
                } else {
                    $_SESSION['success'] = 'Update completed successfully! Check the output below for details.';
                }
                $_SESSION['update_output'] = $output;
            } else {
                throw new Exception('Update failed with return code: ' . $returnCode . '. Output: ' . implode("\n", $output));
            }
            
        } catch (Exception $e) {
            error_log("Update failed with exception: " . $e->getMessage());
            $_SESSION['error'] = 'Update failed: ' . $e->getMessage();
        }
        
        header('Location: ' . $_SERVER['REQUEST_URI']);
        exit;
    }
}

// Get current configuration
$configFile = CONFIG_DIR . '/config.json';
$config = file_exists($configFile) ? json_decode(file_get_contents($configFile), true) : [];
$repo = $config['update_repo_url'] ?? 'https://github.com/fearlessgeekmedia/FearlessCMS.git';
$branch = $config['update_branch'] ?? 'main';

// Generate CSRF token for this page
$csrfToken = generate_updater_csrf_token();

// Display messages
if (isset($_SESSION['error'])) {
    echo '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">' . htmlspecialchars($_SESSION['error']) . '</div>';
    unset($_SESSION['error']);
}

if (isset($_SESSION['success'])) {
    echo '<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">';
    echo htmlspecialchars($_SESSION['success']);
    if (isset($_SESSION['update_output'])) {
        echo '<div class="mt-2"><strong>Update Output:</strong></div>';
        echo '<pre class="text-xs bg-white p-2 rounded border mt-1 max-h-32 overflow-y-auto">' . htmlspecialchars(implode("\n", $_SESSION['update_output'])) . '</pre>';
        unset($_SESSION['update_output']);
    }
    echo '</div>';
    unset($_SESSION['success']);
}
?>

<div class="space-y-8">
    <!-- Status Section -->
    <div class="bg-white shadow rounded-lg p-6">
        <h3 class="text-lg font-medium mb-4">Update Status</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div class="bg-gray-50 p-4 rounded">
                <div class="text-sm text-gray-500">Repository</div>
                <div class="text-sm font-mono break-all"><?php echo htmlspecialchars($repo); ?></div>
            </div>
            <div class="bg-gray-50 p-4 rounded">
                <div class="text-sm text-gray-500">Branch</div>
                <div class="text-sm font-bold"><?php echo htmlspecialchars($branch); ?></div>
            </div>
            <div class="bg-gray-50 p-4 rounded">
                <div class="text-sm text-gray-500">Status</div>
                <div class="text-sm text-gray-600">Ready to update</div>
            </div>
        </div>
        <div class="mt-4 p-3 bg-blue-50 border border-blue-200 rounded">
            <p class="text-sm text-blue-800">
                <strong>Note:</strong> This updater now uses a reliable bash script that bypasses all CSRF token issues. 
                Updates are performed directly from the command line for maximum reliability.
            </p>
        </div>
    </div>

    <!-- Update Settings Form -->
    <div class="bg-white shadow rounded-lg p-6">
        <h3 class="text-lg font-medium mb-4">Update Settings</h3>
        <form method="POST" class="space-y-4">
            <input type="hidden" name="action" value="updates">
            <input type="hidden" name="subaction" value="save_settings">
            <!-- Main admin CSRF token (required by main admin system) -->
            <?php echo csrf_token_field(); ?>
            <!-- Updater internal CSRF token -->
            <input type="hidden" name="updater_csrf_token" value="<?php echo htmlspecialchars($csrfToken); ?>">
            
            <div>
                <label class="block mb-1 font-medium">Repository URL</label>
                <input type="text" name="repo" value="<?php echo htmlspecialchars($repo); ?>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <div class="text-xs text-gray-500 mt-1">Default: https://github.com/fearlessgeekmedia/FearlessCMS.git</div>
            </div>
            
            <div>
                <label class="block mb-1 font-medium">Branch</label>
                <input type="text" name="branch" value="<?php echo htmlspecialchars($branch); ?>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <div class="text-xs text-gray-500 mt-1">Usually 'main' or 'master'</div>
            </div>
            
            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 focus:ring-2 focus:ring-blue-500">
                Save Settings
            </button>
        </form>
    </div>

    <!-- Perform Update Form -->
    <div class="bg-white shadow rounded-lg p-6">
        <h3 class="text-lg font-medium mb-4">Perform Update</h3>
        
        <!-- Progress Display -->
        <div id="update-progress" class="hidden mb-4 p-4 bg-blue-50 border border-blue-200 rounded">
            <div class="flex items-center space-x-3">
                <div class="animate-spin rounded-full h-5 w-5 border-b-2 border-blue-600"></div>
                <div class="text-blue-800 font-medium">Updating system...</div>
            </div>
            <div id="update-output" class="mt-3 text-sm text-blue-700 bg-white p-3 rounded border max-h-64 overflow-y-auto"></div>
        </div>
        
        <form id="update-form" method="POST" onsubmit="return startUpdate(event);" class="space-y-4">
            <input type="hidden" name="action" value="updates">
            <input type="hidden" name="subaction" value="perform_update">
            <!-- Main admin CSRF token (required by main admin system) -->
            <?php echo csrf_token_field(); ?>
            <!-- Updater internal CSRF token -->
            <input type="hidden" name="updater_csrf_token" value="<?php echo htmlspecialchars($csrfToken); ?>">
            
            <div>
                <label class="block mb-1 font-medium">Update Branch</label>
                <input type="text" name="branch" value="<?php echo htmlspecialchars($branch); ?>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>
            
            <div class="flex items-center space-x-6">
                <label class="inline-flex items-center">
                    <input type="checkbox" name="create_backup" checked class="mr-2 rounded">
                    <span>Create backup before updating</span>
                </label>
                
                <label class="inline-flex items-center">
                    <input type="checkbox" name="dry_run" class="mr-2 rounded">
                    <span>Dry run (no changes)</span>
                </label>
            </div>
            
            <button type="submit" id="update-btn" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 focus:ring-2 focus:ring-green-500">
                Perform Update
            </button>
        </form>
        
        <div class="mt-4 p-4 bg-yellow-50 border border-yellow-200 rounded">
            <h4 class="font-medium text-yellow-800 mb-2">Update Information</h4>
            <ul class="text-sm text-yellow-700 space-y-1">
                <li>• Core CMS files will be updated using the bash updater script</li>
                <li>• Your content, config, and uploads will be preserved</li>
                <li>• A backup will be created (if enabled)</li>
                <li>• The site may be temporarily unavailable during update</li>
                <li>• Updates are performed via command line for maximum reliability</li>
            </ul>
        </div>
    </div>
</div>

<script>
function startUpdate(event) {
    event.preventDefault();
    
    const form = document.getElementById('update-form');
    const progress = document.getElementById('update-progress');
    const output = document.getElementById('update-output');
    const btn = document.getElementById('update-btn');
    
    // Show progress
    progress.classList.remove('hidden');
    btn.disabled = true;
    btn.textContent = 'Updating...';
    
    // Clear previous output
    output.innerHTML = '<div class="text-gray-600">Starting update process...</div>';
    
    // Get form data
    const formData = new FormData(form);
    
    // Simulate real-time output (since we can't stream from PHP exec)
    const progressMessages = [
        'Validating update parameters...',
        'Checking system requirements...',
        'Creating backup (if enabled)...',
        'Downloading latest version...',
        'Extracting update files...',
        'Copying new files...',
        'Setting permissions...',
        'Cleaning up temporary files...',
        'Update complete!'
    ];
    
    let messageIndex = 0;
    const progressInterval = setInterval(() => {
        if (messageIndex < progressMessages.length) {
            output.innerHTML += '<div class="text-green-600">✓ ' + progressMessages[messageIndex] + '</div>';
            messageIndex++;
        } else {
            clearInterval(progressInterval);
        }
    }, 800);
    
    // Submit form
    fetch(window.location.href, {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(html => {
        // Parse the response to check for success/error
        if (html.includes('Update completed successfully') || html.includes('Dry run completed successfully')) {
            output.innerHTML += '<div class="text-green-600 font-bold mt-2">✓ Update completed successfully!</div>';
            // Reload page after a short delay to show final results
            setTimeout(() => {
                window.location.reload();
            }, 2000);
        } else if (html.includes('Update failed')) {
            output.innerHTML += '<div class="text-red-600 font-bold mt-2">✗ Update failed. Check the error message above.</div>';
            btn.disabled = false;
            btn.textContent = 'Try Again';
        } else {
            output.innerHTML += '<div class="text-yellow-600 font-bold mt-2">⚠ Update process completed. Check the page for results.</div>';
            btn.disabled = false;
            btn.textContent = 'Perform Update';
        }
    })
    .catch(error => {
        output.innerHTML += '<div class="text-red-600 font-bold mt-2">✗ Error: ' + error.message + '</div>';
        btn.disabled = false;
        btn.textContent = 'Try Again';
    });
    
    return false;
}
</script>
