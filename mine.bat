setlocal enabledelayedexpansion

set POST_FILE=data\posts.csv
set SITE_DIR=site
set COMMIT_MSG=Add Posts (Auto)


echo STEP 1: Run main.py
python main.py
if !ERRORLEVEL!  neq 0 (
    echo main.py failed!
    exit /b !ERRORLEVEL! 
)

set CHANGED=0
git fetch origin >nul 2>&1
git diff --quiet HEAD -- "%POST_FILE%"
if !ERRORLEVEL! neq 0 (
    echo %POST_FILE% has changed!
    set CHANGED=1
) else (
    echo %POST_FILE% has NOT changed.
    exit /b !ERRORLEVEL!
)

echo STEP 2: Run post-maker.py
if !CHANGED! == 1 (
    echo Running post-maker.py...
    python post-maker.py
    if !ERRORLEVEL! neq 0 (
        echo post-maker.py failed!
        exit /b !ERRORLEVEL!
    )
)

echo STEP 3: Check if site directory changed
git diff --quiet HEAD -- "%SITE_DIR%"
if !ERRORLEVEL! neq 0 (
    echo Detected changes in %SITE_DIR%.
    set CHANGED=1
) else (
    echo No changes in %SITE_DIR%.
)


echo STEP 4: Commit and push if needed
if !CHANGED! == 1 (
    echo Changes detected, committing and pushing...
    git add "%POST_FILE%" "%SITE_DIR%" "config.json" 2>nul
    git commit -m "%COMMIT_MSG%"
    git push origin HEAD
    echo Pushed updates to GitHub.
) else (
    echo No changes detected, skipping push.
)

echo.
echo Done!
endlocal