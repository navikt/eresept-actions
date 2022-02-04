# Contains common eresept actions

_Disclaimer!_ I strongly advise against depending on these actions for other projects than eresept, 
as they could change or disappear any time. Make your own copy if you find them useful.

## badges

To use and create the badges in the `badges-*` actions you need an empty branch 
in your repository called badges.

Several actions are needed to create a badge. One to check out the branch. 
One or more actions to create the badge(s). 
And finally a last step to commit all the badges.

An example:
```
      - name: Checkout badges
        uses: navikt/eresept-actions/badges-checkout@main
        
      - name: Some silly badge
        uses: navikt/eresept-actions/badges-create@main
        with:
          left: 'silly text'
          right: 'some value, maybe from an output from an earlier step'
          color: 'blue'
          filename: 'silly'

      - name: Another silly badge
        uses: navikt/eresept-actions/badges-create@main
        with:
          left: 'another text'
          right: 'foo'
          color: 'ff69b4'
          filename: 'foo'

      - name: Commit badges
        uses: navikt/eresept-actions/badges-commit@main

```

## coverage

If you use jacoco to create coverage reports you can use the action `badges-jacoco`. 
This action also needs the badges branch to be checked out first, and committed after.

An example:
```
      - name: Checkout badges
        uses: navikt/eresept-actions/badges-checkout@main

      - name: Create coverage badges
        uses: navikt/eresept-actions/badges-jacoco@main

      - name: Calculate execution time
        id: exectime
        run: |
          END_TIME=$(date +%s)
          echo "::set-output name=exectime::$(( $END_TIME - ${{ steps.starttime.outputs.starttime }} ))"

      - name: Time used badge
        uses: navikt/eresept-actions/badges-create@main
        with:
          left: 'build execution time'
          right: '${{ steps.exectime.outputs.exectime }}'
          color: 'blue'
          filename: 'rel-exec-time'

      - name: Commit badges
        uses: navikt/eresept-actions/badges-commit@main
```

The action creates badges for coverage (named `jacoco.svg`) and badges for lines (`lines.svg`) 
and methods (`methods.svg`). All numbers are calculated from the `jacoco.csv` file.

If the file `jacoco.csv` is the result of a `jacoco aggregate` goal, 
then badges are created for all modules as well. The badges for the modules 
will be named `jacoco-module-name-1.svg`, `jacoco-module-name-2.svg`, `lines-module-name-1.svg`' and so on.

To create an aggregate report you need a report module to be run after all the other modules. 
This module will need all the other modules as dependencies. 
See https://github.com/jacoco/jacoco/wiki/MavenMultiModule for more information.

Example:
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>foo-parent</artifactId>
        <groupId>no.yes.foo</groupId>
        <version>3.3.6-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>report</artifactId>

    <dependencies>
        <dependency>
            <groupId>no.yes.foo</groupId>
            <artifactId>foobar</artifactId>
        </dependency>
        <dependency>
            <groupId>no.yes.foo</groupId>
            <artifactId>foobar2</artifactId>
        </dependency>
        <dependency>
            <groupId>no.yes.foo</groupId>
            <artifactId>foobar3</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>report-aggregate</id>
                        <phase>verify</phase>
                        <goals>
                            <goal>report-aggregate</goal>
                        </goals>
                        <configuration>
                            <outputDirectory>${project.basedir}/../target/site/jacoco</outputDirectory>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

</project>
```

## the rest

The other actions in the `.github/workflows` directory are ordinary build and release actions 
intended for eresept projects.