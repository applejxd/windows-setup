@echo off

powershell -Command "-join ((1..8) | ForEach-Object {Get-Random -input ([char[]]((48..57) + (65..90) + (97..122)))})" | clip