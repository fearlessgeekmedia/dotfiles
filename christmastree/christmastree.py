#!/usr/bin/env python3

import curses
import time

TREE_CHAR = "▲"
TRUNK_CHAR = "█"
STAR_CHAR = "★"

MESSAGE = "Merry Christmas! Happy Holidays!"

def draw_tree(stdscr):
    curses.curs_set(0)
    stdscr.nodelay(True)
    stdscr.clear()

    height = 12
    trunk_height = 3

    max_y, max_x = stdscr.getmaxyx()
    center_x = max_x // 2
    start_y = 2

    # Colors
    curses.start_color()
    curses.use_default_colors()
    curses.init_pair(1, curses.COLOR_GREEN, -1)
    curses.init_pair(2, curses.COLOR_YELLOW, -1)
    curses.init_pair(3, curses.COLOR_WHITE, -1)

    # Star
    stdscr.attron(curses.color_pair(2))
    stdscr.addstr(start_y, center_x, STAR_CHAR)
    stdscr.attroff(curses.color_pair(2))

    # Tree body
    stdscr.attron(curses.color_pair(1))
    for i in range(height):
        y = start_y + 1 + i
        width = 2 * i + 1
        x = center_x - i
        stdscr.addstr(y, x, TREE_CHAR * width)
    stdscr.attroff(curses.color_pair(1))

    # Trunk
    stdscr.attron(curses.color_pair(3))
    trunk_y = start_y + height + 1
    for i in range(trunk_height):
        stdscr.addstr(trunk_y + i, center_x - 1, TRUNK_CHAR * 3)
    stdscr.attroff(curses.color_pair(3))

    # Message
    msg_y = trunk_y + trunk_height + 2
    msg_x = center_x - len(MESSAGE) // 2
    stdscr.addstr(msg_y, msg_x, MESSAGE)

    stdscr.refresh()

    # Exit on keypress or after timeout
    start = time.time()
    while time.time() - start < 30:
        if stdscr.getch() != -1:
            break
        time.sleep(0.1)


def main():
    curses.wrapper(draw_tree)


if __name__ == "__main__":
    main()

