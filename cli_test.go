package main

import (
	"testing"
	"os"
	"log"
	"io/fs"
	"bytes"
)

func TestApply(t *testing.T) {
	mockHomePath := t.TempDir()
	mockDotfilesPath := t.TempDir()

	mockHome, err := os.OpenRoot(mockHomePath)
	if err != nil {
		log.Fatalf("failed to open root: %s", err)
	}

	mockDotfiles, err := os.OpenRoot(mockDotfilesPath)
	if err != nil {
		log.Fatalf("failed to open root: %s", err)
	}

	dotfilesZshrc := []byte("some zshrc stuff")
	dotfilesZshenv := []byte("other zshenv stuff")
	dotfilesNvimInit := []byte("nvim init stuff")
	dotfilesNvimPlugin := []byte("nested nvim plugin stuff")

	if err := mockDotfiles.WriteFile(".zshrc", dotfilesZshrc, fs.ModePerm); err != nil {
		log.Fatalf("failed to write file: %s", err)
	}

	if err := mockDotfiles.WriteFile(".zshenv", dotfilesZshenv, fs.ModePerm); err != nil {
		log.Fatalf("failed to write file: %s", err)
	}

	if err := mockDotfiles.MkdirAll(".config/nvim/lua", fs.ModePerm); err != nil {
		log.Fatalf("failed to create dir: %s", err)
	}

	if err := mockDotfiles.WriteFile(".config/nvim/init.lua", dotfilesNvimInit, fs.ModePerm); err != nil {
		log.Fatalf("failed to write file: %s", err)
	}

	if err := mockDotfiles.WriteFile(".config/nvim/lua/plugins.lua", dotfilesNvimPlugin, fs.ModePerm); err != nil {
		log.Fatalf("failed to write file: %s", err)
	}

	if err := apply(mockHome, mockDotfiles); err != nil {
		log.Fatalf("failed to apply: %s", err)
	}

	appliedZshrc, err := mockHome.ReadFile(".zshrc")
	if err != nil {
		log.Fatalf("failed to read file: %s", err)
	}

	if !bytes.Equal(dotfilesZshrc, appliedZshrc) {
		log.Fatalf("applied zshrc value '%s' not equal to dotfiles zshrc '%s'", string(appliedZshrc), string(dotfilesZshrc))
	}

	appliedZshenv, err := mockHome.ReadFile(".zshenv")
	if err != nil {
		log.Fatalf("failed to read file: %s", err)
	}

	if !bytes.Equal(dotfilesZshenv, appliedZshenv) {
		log.Fatalf("applied zshenv value '%s' not equal to dotfiles zshenv '%s'", string(appliedZshenv), string(dotfilesZshenv))
	}

	appliedNvimInit, err := mockHome.ReadFile(".config/nvim/init.lua")
	if err != nil {
		log.Fatalf("failed to read file: %s", err)
	}

	if !bytes.Equal(dotfilesNvimInit, appliedNvimInit) {
		log.Fatalf("applied nvim init value '%s' not equal to dotfiles nvim init '%s'", string(appliedNvimInit), string(dotfilesNvimInit))
	}

	appliedNvimPlugin, err := mockHome.ReadFile(".config/nvim/lua/plugins.lua")
	if err != nil {
		log.Fatalf("failed to read file: %s", err)
	}

	if !bytes.Equal(dotfilesNvimPlugin, appliedNvimPlugin) {
		log.Fatalf("applied nvim plugin value '%s' not equal to dotfiles nvim plugin '%s'", string(appliedNvimPlugin), string(dotfilesNvimPlugin))
	}
}
