# GitHub Azure DevOps Tasks
A suite of build tasks focused on helping automate GitHub Releases

# Getting Started
This needs to be updated

1. Goto VSTS Marketplace and find the DNN Module Set Version Extension [https://marketplace.visualstudio.com/items?itemName=hoefling-software.SetVersionDNN](https://marketplace.visualstudio.com/items?itemName=hoefling-software.SetVersionDNN)
2. Install module to your VSTS Instance
3. Add Task to your build and configure parameters
4. Run build

You should now have properly versioned modules

# Development Getting Started
Install the tfx-cli 
```npm i -g tfx-cli```

Package the extension using the tfx-cli
```tfx extension create --manifest-globs vss-extension.json```

Goto your publisher account [https://marketplace.visualstudio.com](https://marketplace.visualstudio.com) and upload the generated vsix