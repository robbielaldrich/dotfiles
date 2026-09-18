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

	if err := mockDotfiles.WriteFile(".zshrc", dotfilesZshrc, fs.ModePerm); err != nil {
		log.Fatalf("failed to write file: %s", err)
	}

	if err := mockDotfiles.WriteFile(".zshenv", dotfilesZshenv, fs.ModePerm); err != nil {
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
}
