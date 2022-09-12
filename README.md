# sg-flex

A Flexbox node for Roku's SceneGraph.

- [Install](#install)
  * [With ropm](#with-ropm)
  * [Manual install](#manual-install)
- [Usage](#usage)
  * [Directly in your XML](#directly-in-your-xml)
  * [Or programatically](#or-programatically)
- [API](#api)
- [Current Limitations](#current-limitations)
- [Running the test project](#running-the-test-project)
  * [Option 1: Sideload the application](#option-1-sideload-the-application)
  * [Option 2: Use VSCode](#option-2-use-vscode)
- [Questions and suggestions](#questions-and-suggestions)
- [Contributing](#contributing)

## Install

### With [ropm](https://github.com/rokucommunity/ropm)

```
(tbd)
```

### Manual install

Grab our latest release from our [Releases](https://github.com/haystacknews/sg-flex/releases) page and copy the contents of the `components` and `source` folders into the root of the equivalent folders in your application. Remember to update the import scripts if you copy them anywhere else.

## Usage

### Directly in your XML

```xml
<SGFlex
    id="sgFlex"
    direction="row"
    justifyContent="spaceBetween"
    alignItems="center"
    width="1790"
    height="596"
    translation="[64, 101]"
>
    <Rectangle width="170" height="170" color="0xA90F0F">
        <Label text="0" />
    </Rectangle>
    <Rectangle width="170" height="170" color="0x2B9857">
        <Label text="1" />
    </Rectangle>
    <Rectangle width="170" height="170" color="0x2B4A98">
        <Label text="2" />
    </Rectangle>
</SGFlex>
```

### Or programatically

```brs
m.sgFlex = CreateObject("roSGNode", "SGFlex")

' Consider that `flexify()` will be called for each of these assignments.
m.sgFlex.width = 1790
m.sgFlex.height = 596
m.sgFlex.direction = "row"
m.sgFlex.justifyContent = "spaceBetween"
m.sgFlex.alignItems = "center"

r1 = CreateObject("roSGNode", "Rectangle")
r1.width = 170
r1.height = 170

r2 = r1.clone()
r3 = r1.clone

m.sgFlex.appendChild(r1)
m.sgFlex.appendChild(r2)
m.sgFlex.appendChild(r3)

' Call flexify again due to limitation #1
m.sgFlex.callFunc("flexify")
```

## API

- `width` and `height`: Dimensions of the flex container. If missing, they will be replaced by the accumulated width and height of the children.

- `direction`: The direction of the main axis.
    - `row` (default)
    - `column`

- `justifyContent`: The flex alignment of the main axis.
    - `flexStart` (default)
    - `flexEnd`
    - `center`
    - `spaceBetween`
    - `spaceAround`
    - `spaceEvenly`

- `alignItems`:
    - `flexStart` (default)
    - `flexEnd`
    - `center`
    
- `flexifyOnce`: A boolean value indicating if the `SGFlex` node should only call `flexify()` once. If true, the node will ignore all the function calls to `flexify()` except the first one.
    
- `flexify()`: Call this function every time you want to re calculate and apply the children alignments.

## Current Limitations

- The `SGFlex` node is not reactive to changes to its children. To update the layout you need to call the `flexify` function.

- The `SGFlex` node assumes its children have their coordinate center at the top left. Otherwise they will not be properly aligned.
    - For example `LayoutGroup` nodes with values other than `horizAlignment="left"` and `vertAlignment="top"` will not be laid out properly. Same for `Label` nodes with values other than `horizAlign="left"` and `vertAlign="top"`.
    - Consider replacing `LayoutGroup` nodes with `SGFlex` nodes to aleviate this.

- There are no flexbox-like capabilities for the children (e.g: `order` or `alignSelf`).

## Running the test project

![image](https://user-images.githubusercontent.com/29876959/189559254-212b97e8-1c4d-4c59-9745-03dd7c5882cc.png)


### Option 1: Sideload the application

Grab the `test-project.zip` file from our latest release on the [Releases](https://github.com/haystacknews/sg-flex/releases) page and sideload it into your Roku device following [these instructions](https://www.howtogeek.com/290787/how-to-enable-developer-mode-and-sideload-roku-apps/).

### Option 2: Use VSCode

1. Make sure you have the [BrightScript Language extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript) installed.

> Launch VS Code Quick Open (Ctrl+P), paste the following command, and press enter.

```
ext install RokuCommunity.brightscript
```

2. Clone this repository

```bash
git clone https://github.com/haystacknews/sg-flex.git
```

3. Install the project dependencies (preferibly with Node `>=16.14.2` and NPM `>=8.5.0`)

```bash
npm install
```

3. Go to Run and Debug on the Activity Bar and `Start debugging` with the option `Launch Test App`.

![image](https://user-images.githubusercontent.com/29876959/189559098-15e6e326-64a9-40ef-bb7d-70ff9e7c86df.png)

> The `preLaunchTask` might take a bit to load because it copies the file structure of the test project into a separate folder and runs `ropm install` every time.

## Questions and suggestions

Hi! I'm Arturo Cuya, the main contributor of this project. If you have a question on how to use `sg-flex` or a suggesion on how to improve it, consider one of the following communication channels:

1. Create an issue explaining your question or asking for a feature; or
2. Ping me on the [Roku Developers Slack](https://rokudevelopers.slack.com/)

## Contributing

> todo: explain this nicely

- Remember to fork this repo and making a PR from yours into this instead of pulling this repo and doing modifications directly.

- Use this node environment

```json
"engines": {
  "node": ">=16.14.2",
  "npm": ">=8.5.0"
},
```

- Use BrighterScript

- Switch between developing the component and the test project by changing the `rootDir` in `bsconfig.json`

- Testing is done with `roca` and `brs`, using a BrighterScript plugin located in `bsconfig/plugins` to disable features not supported by `brs`. Run the tests with `npm run test`
