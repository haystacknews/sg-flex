import type { BeforeFileTranspileEvent, CompilerPlugin } from 'brighterscript';
import { isBrsFile, createVisitor, WalkMode } from 'brighterscript';

/**
 * This plugin will act on found annotations.
 * Available annotations are:
 * - `@deviceOnly`: Removes the annotated statement from the code.
 * Use together with `bsconfig.test.json` as an indentifier for
 * non device running environments (e.g: `brs` interpreter or `roca`).
 */
export default function plugin() {
    return {
        name: 'annotations',
        beforeFileTranspile: (event: BeforeFileTranspileEvent) => {
            if (isBrsFile(event.file)) {
                for (const func of event.file.parser.references.functionExpressions) {
                    // TODO: Ask Bronley how to affect all statements and substatements.
                    // TODO: What about try/catch/throw?
                    func.body.walk(createVisitor({
                        DottedSetStatement: (statement) => {
                            if (statement.annotations?.find(a => a.name === 'deviceOnly')) {
                                event.editor.overrideTranspileResult(statement, '');
                            }
                        },
                        ExpressionStatement: (statement) => {
                            if (statement.annotations?.find(a => a.name === 'deviceOnly')) {
                                event.editor.overrideTranspileResult(statement, '');
                            }
                        }
                    }), {
                        walkMode: WalkMode.visitStatements
                    });
                }
            }
        }
    } as CompilerPlugin;
}

/*
Advice to find what kind of statement you should override:
1. Reduce the scope of your plugin to the file you are interested in.

```
if (isBrsFile(event.file) && event.file.pkgPath.includes('SGFlexModel')) {
```

2. Go through all the functionExpressions' functionStatements
(limiting yourself to the function you are interested in) and check for
body statements with annotations.

```
for (const s of event.file.parser.references.functionExpressions) {
    if (s.functionStatement.name.text === 'validateDirection') {
        for (const bodyStatement of s.body.statements) {
            if (bodyStatement.annotations) {
                console.log(bodyStatement);
            }
        }
    }
}
```

3. The first line of the console log will tell you the type of the statement
you want to override.
*/
