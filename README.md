Discord.gd Tutorial Discord Bot v2
=========================================
### 2nd version of making a bot using [Discord.gd](https://github.com/3ddelano/discord.gd) tutorial in Godot engine!

> 100% GDScript

<br>
<img alt="Godot4" src="https://img.shields.io/badge/-Godot 4.x-478CBF?style=for-the-badge&logo=godotengine&logoWidth=20&logoColor=white" />

## [Watch tutorial playlist on YouTube](https://youtube.com/playlist?list=PL5t0hR7ADzuk4M_GDeGcW7cDjG_xp710p)


#### Godot version compatibility

- Godot 4.x - [main branch](https://github.com/3ddelano/discord-bot-v2-godot/tree/main)
- Godot 3.x - [godot3 branch](https://github.com/3ddelano/discord-bot-v2-godot/tree/godot3)


Features
--------------

- Commands are in separate files
- Easily scale number of commands and interactions
- Commands support aliases, usage, description and more
- Advanced help command which dynamically generates help from all commands


Getting Started
----------

1. Download this repo.
2. Rename the file `.env-sample` to `.env` and paste your BOT_TOKEN in the file.
3. Open the `project.godot` file in Godot. Then run the `Main.tscn` scene.

Previous Source Code
----------
For source code of previous parts of the tutorial, see [branches](https://github.com/3ddelano/discord-bot-v2-godot/branches)

Host the bot for free on Heroku (free version was discontined by Heroku on November 28, 2022)
----------
1. Create a new app on [Heroku](https://heroku.com) (Needs signing up for a Free account)
2. Goto the `Settings` tab, in the `Config Vars` section, click `Reveal Config Vars`
3. Add three config vars:
   - `GODOT_VERSION`: 3.4.2
   - `HEROKU_URL`: https://\<your-app-name\>.herokuapp.com
   - `BOT_TOKEN`: \<your discord bot token\>
4. In the `Buildpacks` section, click `Add Buildpack`, and paste this URL
   
   `https://github.com/3ddelano/heroku-buildpack-godot`
5. Finally goto the `Deploy` tab and follow the instructions to push your source code to Heroku (you can directly use the GitHub flow or even use the Heroku CLI).

Support
----------
<a href="https://www.buymeacoffee.com/3ddelano" target="_blank"><img height="41" width="174" src="https://cdn.buymeacoffee.com/buttons/v2/default-red.png" alt="Buy Me A Coffee" width="150" ></a>
Want to support in other ways? Contact me on Discord: `@3ddelano#6033`

For doubts / help / bugs / problems / suggestions do join: [3ddelano Cafe](https://discord.gg/FZY9TqW)