# build

My go application build subtree supporting auto build versioning and application other information.

layouts：
```shell
.
├── bin
├── main.go
├── vendor
│   └── github.com
│       └── sevenNt
│           └── ares
```

## Quick Start
**add subtree**
```
cd $project                                                    # 进入到应用工作目录
git remote add -f build git@github.com:sevenNt/build.git        # 强制添加sevenNt/build远程仓库
rm -r ./build && git add build && git commit -m "rm old build" # 删除旧build子树
git subtree add --prefix=build build master --squash           # 添加新build子树
```

## Other directives
**pull subtree**
```
git subtree pull --prefix=build build master --squash # 更新build子树
```
