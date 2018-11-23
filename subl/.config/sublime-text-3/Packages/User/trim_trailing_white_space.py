#!/usr/bin/env python3
import sublime, sublime_plugin


def trim_trailing_white_space(view, edit):
    regions = view.find_all('[\t ]+$')
    regions.reverse()
    for region in regions:
        view.erase(edit, region)


class TrimTrailingWhiteSpaceCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        trim_trailing_white_space(self.view, edit)
