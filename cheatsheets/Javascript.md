
## Console methods

    console.table([ ['a','b','c'], [1,2,3] ] );

    console.table(
        {"London":{population:8173194, country:"UK", elevation:"24m"},
        "New York":{population:8336697, country:"USA", elevation:"10m"}},
        ["population", "country"])

    console.assert(!true, 'This is not true');

    console.time(label);

    console.timeStamp(label);
    
    
console levels: Log, Info, Debug, Warn, Error
    
    
## Debugger

Last element selected: $0

Last expression: $_

In Firebug, you can select further previous elements you have highlighted using $n(2) - $n(5).

Insert a breakpoint: 'debugger;'

XPath evaluation: $x(xpath [, contextNode [, resultType]])
