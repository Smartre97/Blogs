@echo off
:: 设置字符集为UTF-8防止乱码
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   博客初始化管理工具 (Python 环境检测)
echo ========================================

:: 1. 尝试调用 Python 3.13 (Python Launcher 方式)
py -3.13 --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [状态] 检测到 Python 3.13.5，正在启动...
    py -3.13 run_me.py
    goto end_process
)

:: 2. 如果没找到 3.13，检查系统默认的 python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 找不到任何有效的 python 命令。
    echo 请确认 Python 是否已安装并勾选了 "Add to PATH"。
    goto error_pause
)

:: 3. 提取默认 Python 的版本号并判断是否 >= 3.10
for /f "tokens=2 delims= " %%v in ('python --version') do set ver_str=%%v
for /f "tokens=1,2 delims=." %%a in ("%ver_str%") do (
    set major=%%a
    set minor=%%b
)

if %major% equ 3 (
    if %minor% geq 10 (
        echo [状态] 未找到 3.13，但发现兼容版本 Python %ver_str%，正在启动...
        python run_me.py
        goto end_process
    ) else (
        echo [错误] 找到 Python %ver_str%，但版本低于 3.10。
        goto error_pause
    )
) else (
    echo [错误] 找到的 Python 版本为 %ver_str%，非 Python 3 系列。
    goto error_pause
)

:end_process
if %errorlevel% neq 0 (
    echo.
    echo [错误] run_me.py 执行过程中出错，请检查上方 Python 输出信息。
) else (
    echo.
    echo ✅ 程序执行成功完成！
)
pause
exit /b 0

:error_pause
echo.
echo ❌ 环境检测失败，请检查 Python 安装情况。
pause
exit /b 1