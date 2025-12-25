import React from 'react';
import { render, Text, Box } from 'ink';
import SelectInput from 'ink-select-input';
import Parser from 'rss-parser';
import { execSync } from 'child_process';

const App = () => {
  const [feed, setFeed] = React.useState(null);
  const [selectedItem, setSelectedItem] = React.useState(null);
  const [error, setError] = React.useState(null);

  React.useEffect(() => {
    const parser = new Parser();
    parser.parseURL('https://www.linuxtoday.com/feed/')
      .then(setFeed)
      .catch(err => setError(err.message));
  }, []);

  if (error) return <Text color="red">Error: {error}</Text>;
  if (!feed) return <Text>Loading...</Text>;

  if (selectedItem) {
    const actionItems = [
      { label: 'Back to list', value: 'back' },
      { label: 'Open link in browser', value: 'link' },
    ];

    return (
      <Box flexDirection="column" padding={1}>
        <Text bold color="green">{selectedItem.title}</Text>
        <Text>{selectedItem.contentSnippet || 'No description available.'}</Text>
        <SelectInput
          items={actionItems}
          onSelect={(item) => {
            if (item.value === 'back') setSelectedItem(null);
            if (item.value === 'link') {
              try {
                execSync(`xdg-open "${selectedItem.link}"`, { stdio: 'ignore' });
              } catch (error) {
                console.error('Failed to open link:', error.message);
              }
            }
          }}
        />
      </Box>
    );
  }

  const items = feed.items.map((item, index) => ({
    label: item.title,
    value: index,
  }));

  return (
    <Box flexDirection="column" padding={1}>
      <Text bold color="blue">Linux Today Feed</Text>
      <Text>Use arrow keys to navigate, Enter to select an article, 'q' to quit</Text>
      <SelectInput items={items} onSelect={(item) => setSelectedItem(feed.items[item.value])} />
    </Box>
  );
};

render(<App />);
