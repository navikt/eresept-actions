# Contains common eresept actions

_Disclaimer!_ I advise against depending on these actions for other projects than eresept, 
as they could change or disappear any time. Make your own copy if you find them useful.

## badges

To use and create the badges in the `badges-*` actions you need an empty branch 
in your repository called badges.
```
git switch --orphan badges
git commit --allow-empty -m "Initial commit on badges orphan branch"
git push -u origin badges
```

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
          logo: 'logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0NDggNTEyIj48IS0tISBGb250IEF3ZXNvbWUgUHJvIDYuMS4xIGJ5IEBmb250YXdlc29tZSAtIGh0dHBzOi8vZm9udGF3ZXNvbWUuY29tIExpY2Vuc2UgLSBodHRwczovL2ZvbnRhd2Vzb21lLmNvbS9saWNlbnNlIChDb21tZXJjaWFsIExpY2Vuc2UpIENvcHlyaWdodCAyMDIyIEZvbnRpY29ucywgSW5jLiAtLT48cGF0aCBkPSJNOTYgMzJDOTYgMTQuMzMgMTEwLjMgMCAxMjggMEMxNDUuNyAwIDE2MCAxNC4zMyAxNjAgMzJWNjRIMjg4VjMyQzI4OCAxNC4zMyAzMDIuMyAwIDMyMCAwQzMzNy43IDAgMzUyIDE0LjMzIDM1MiAzMlY2NEg0MDBDNDI2LjUgNjQgNDQ4IDg1LjQ5IDQ0OCAxMTJWMTYwSDBWMTEyQzAgODUuNDkgMjEuNDkgNjQgNDggNjRIOTZWMzJ6TTQ0OCA0NjRDNDQ4IDQ5MC41IDQyNi41IDUxMiA0MDAgNTEySDQ4QzIxLjQ5IDUxMiAwIDQ5MC41IDAgNDY0VjE5Mkg0NDhWNDY0eiIvPjwvc3ZnPg=='

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
        run: |
          END_TIME=$(date +%s)
          echo "exectime=$(( $END_TIME - ${{ steps.starttime.outputs.starttime }} ))" >> $GITHUB_ENV

      - name: Time used badge
        uses: navikt/eresept-actions/badges-create@main
        with:
          left: 'build execution time'
          right: '${{ env.exectime }}'
          color: 'blue'
          filename: 'rel-exec-time'

      - name: Commit badges
        uses: navikt/eresept-actions/badges-commit@main
```

The action creates badges for coverage (named `jacoco.svg`) and badges for lines (`lines.svg`) 
and methods (`methods.svg`). All numbers are calculated from the `jacoco.csv` file.

### coverage for multi-module projects

If the file `jacoco.csv` is the result of a `jacoco aggregate` goal, 
then badges are created for all modules as well. If the modules are named `module-name-1`, `module-name-2` etc 
the badges for the modules will be named `jacoco-module-name-1.svg`, `jacoco-module-name-2.svg` and so on.

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

## build configs

The directory `configs` does not contain things related to actions, but some common config files 
that are served with https://raw.githubusercontent.com/. 
