#!/bin/bash
# 推送到 GitHub 的脚本

# 配置
REPO_NAME="alibabacloud-swas-py-skills"
GITHUB_USERNAME="your-github-username"  # 请修改为你的 GitHub 用户名

# 检查是否已经配置了 git 用户信息
git config --global user.name
if [ $? -ne 0 ]; then
    echo "请配置 git 用户名：git config --global user.name \"Your Name\""
    exit 1
fi

git config --global user.email
if [ $? -ne 0 ]; then
    echo "请配置 git 邮箱：git config --global user.email \"your@email.com\""
    exit 1
fi

# 进入项目目录
cd /tmp/alibabacloud-swas-py-skills

# 创建 GitHub 仓库（需要 gh CLI）
if command -v gh &> /dev/null; then
    echo "检测到 gh CLI，正在创建 GitHub 仓库..."
    gh repo create $REPO_NAME --public --source=. --push
    echo "完成！仓库地址：https://github.com/$GITHUB_USERNAME/$REPO_NAME"
else
    echo "gh CLI 未安装，请按照以下步骤操作："
    echo ""
    echo "1. 在 GitHub 上创建新仓库："
    echo "   访问 https://github.com/new"
    echo "   仓库名称：$REPO_NAME"
    echo "   选择：Public（公开）"
    echo "   不要勾选 Initialize this repository with a README"
    echo ""
    echo "2. 推送代码到 GitHub："
    echo "   cd /tmp/alibabacloud-swas-py-skills"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
    echo ""
    echo "或者安装 gh CLI 后自动创建："
    echo "   sudo apt update && sudo apt install gh -y"
    echo "   gh auth login"
    echo "   cd /tmp/alibabacloud-swas-py-skills"
    echo "   gh repo create $REPO_NAME --public --push"
fi
