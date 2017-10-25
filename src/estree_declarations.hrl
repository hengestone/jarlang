% Generates a declaration
declaration() ->
    node().

% Generates a variable declaration
variableDeclaration(Declarations, Kind) when is_list(Declarations)  ->
    updateRecord(declaration(), [{"type", <<"VariableDeclaration">>}, {"declarations", Declarations}, {"kind", Kind}]);
variableDeclaration(Declarations, Kind) ->
    variableDeclaration([Declarations], Kind).

% Generates a variable declarator
variableDeclarator(Identifier, Init) ->
    node("VariableDeclarator", [{"id", Identifier}, {"init", Init}]).

% Generate a function declaration
functionDeclaration(Identifier, Params, Body) when is_list(Params) ->
    updateRecord(declaration(), [{"type", <<"FunctionDeclaration">>}, {"id", Identifier}, {"params", Params}, {"body", Body}]);
functionDeclaration(Identifier, Params, Body) ->
    functionDeclaration(Identifier, [Params], Body).