import type { BeforeFileTranspileEvent, CompilerPlugin, Statement } from 'brighterscript';
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
                    func.body.walk(createVisitor({
                        DottedSetStatement: (statement) => handleDeviceOnlyAnnotation(statement, event),
                        ExpressionStatement: (statement) => handleDeviceOnlyAnnotation(statement, event)
                        // TODO: Uncomment this when `ThrowStatement` is supported as an argument for `createVisitor`
                        // ThrowStatement: (statement) => handleDeviceOnlyAnnotation(statement, event)
                    }), {
                        walkMode: WalkMode.visitStatements
                    });
                }
            }
        }
    } as CompilerPlugin;
}

function handleDeviceOnlyAnnotation(statement: Statement, event: BeforeFileTranspileEvent) {
    if (statement.annotations?.find(a => a.name === 'deviceOnly')) {
        event.editor.overrideTranspileResult(statement, '');
    }
}
