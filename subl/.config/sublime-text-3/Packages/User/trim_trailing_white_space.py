#!/usr/bin/env python
import sublime, sublime_plugin


def trim_trailing_white_space(view):
    trailing_white_space = view.find_all('[\t ]+$')
    trailing_white_space.reverse()
    edit = view.begin_edit()
    for r in trailing_white_space:
        view.erase(edit, r)
    view.end_edit(edit)


class TrimTrailingWhiteSpaceCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        trim_trailing_white_space(self.view)


class TrimTrailingWhiteSpace(sublime_plugin.EventListener):
    def on_pre_save(self, view):
        if view.settings().get('trim_trailing_white_space_on_save'):
            trim_trailing_white_space(view)


class EnsureNewlineAtEof(sublime_plugin.EventListener):
    def on_pre_save(self, view):
        if view.settings().get('ensure_newline_at_eof_on_save'):
            if view.size() > 0 and view.substr(view.size() - 1) != '\n':
                edit = view.begin_edit()
                view.insert(edit, view.size(), '\n')
                view.end_edit(edit)
