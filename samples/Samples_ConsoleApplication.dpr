program Samples_ConsoleApplication;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  horse,
  XSuperJSON,
  XSuperObject,
  Horse.Jhonson,
  System.JSON,
  REST.Json,
  System.SysUtils;

var
  api: THorse;

begin

  try

    api := THorse.Create;

    api.Use(Jhonson());

    api.Get('/exemplo_objeto_simples',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
        SuperObject: ISuperObject;
        SuperObjectFilhosArray: ISuperObject;
        JsonObject: TJsonObject;
      begin

        SuperObject := SO();

        SuperObject.I['ValorInteiro'] := 0;
        SuperObject.S['ValorString'] := 'Sua String';
        SuperObject.F['ValorReal'] := 0.74158;
        SuperObject.B['ValorBooleano'] := True;

        SuperObject.A['ValorArray'] := SA();

        SuperObjectFilhosArray := SO();
        SuperObjectFilhosArray.S['ValorString'] := 'Seu Valor String 1';
        SuperObject.A['ValorArray'].Add(SuperObjectFilhosArray);

        SuperObjectFilhosArray := SO();
        SuperObjectFilhosArray.S['ValorString'] := 'Seu Valor String 2';
        SuperObject.A['ValorArray'].Add(SuperObjectFilhosArray);

        SuperObjectFilhosArray := SO();
        SuperObjectFilhosArray.S['ValorString'] := 'Seu Valor String 3';
        SuperObject.A['ValorArray'].Add(SuperObjectFilhosArray);

        JsonObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( SuperObject.AsJSON(false,false) ), 0) as TJSONObject;
        Res.Send<TJSONObject>( JsonObject );

      end);

    api.Get('/exemplo_array',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
        SuperObject: ISuperArray;
        SuperObjectFilhosArray: ISuperObject;
        JsonArray: TJsonArray;
      begin

        SuperObject := SA();

        SuperObjectFilhosArray := SO();
        SuperObjectFilhosArray.S['ValorString'] := 'Seu Valor String 1';
        SuperObject.Add(SuperObjectFilhosArray);

        SuperObjectFilhosArray := SO();
        SuperObjectFilhosArray.S['ValorString'] := 'Seu Valor String 2';
        SuperObject.Add(SuperObjectFilhosArray);

        SuperObjectFilhosArray := SO();
        SuperObjectFilhosArray.S['ValorString'] := 'Seu Valor String 3';
        SuperObject.Add(SuperObjectFilhosArray);

        JsonArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( SuperObject.AsJSON() ), 0) as TJsonArray;
        Res.Send<TJSONArray>( JsonArray );

      end);

    api.Listen(9898);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
