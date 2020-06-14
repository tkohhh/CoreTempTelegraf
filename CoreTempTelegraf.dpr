// CoreTemp Windows Telegraf Plugin
// Author: Tom Kewley
// based on:
//    Core Temp shared memory reader demo project
//    Author: Michal Kokorceny
//    Web:    http://74.cz
//    E-mail: michal@74.cz
//
//    Core Temp project home page:
//    http://www.alcpu.com/CoreTemp

program CoreTempTelegraf;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  GetCoreTempInfoDelphi in 'GetCoreTempInfoDelphi.pas';

var
  Data: CORE_TEMP_SHARED_DATA;
  CPU, Core, Index: Cardinal;
  Degree: Char;
  Temp: Single;
  Hostname: String;

function StringToOem(const Str: string): AnsiString;
begin
  Result := AnsiString(Str);
  if Length(Result) > 0 then
    CharToOemA(PAnsiChar(Result), PAnsiChar(Result));
end;

function ComputerName : String;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

begin
  try
    Hostname := ComputerName();
    if fnGetCoreTempInfo(Data) then
    begin
      Writeln('coretemp_cpu,host=' + Hostname
            + ',cpu=' + StringReplace(Trim(Data.sCPUName),' ','_',[rfReplaceAll])
            + ' cpu_speed=' + FloatToStrF(Data.fCPUSpeed, ffFixed, 7, 0)
            + ',fsb_speed=' + FloatToStrF(Data.fFSBSpeed, ffFixed, 7, 0)
            + ',multiplier=' + FloatToStrF(Data.fMultipier, ffFixed, 7, 1)
            + ',vid=' + FloatToStrF(Data.fVID, ffFixed, 7, 2));
      if Data.ucFahrenheit then
        Degree := 'F'
      else
        Degree := 'C';
      for CPU := 0 to Data.uiCPUCnt - 1 do
      begin
        for Core := 0 to Data.uiCoreCnt - 1 do
        begin
          Index := (CPU * Data.uiCoreCnt) + Core;
          if Data.ucDeltaToTjMax then
            Temp := Data.uiTjMax[CPU] - Data.fTemp[Index]
          else
            Temp := Data.fTemp[Index];
          Writeln('coretemp_cpu,host=' + Hostname
                + ',cpu=' + StringReplace(Trim(Data.sCPUName),' ','_',[rfReplaceAll])
                + ',cpu_id=' + IntToStr(CPU)
                + ',core_id=' + IntToStr(Core)
                + ',unit=' + Degree
                + ' temperature=' + FloatToStrF(Temp, ffFixed, 7, 0));
        end;
      end;
    end
    else
    begin
      Writeln('Error: Core Temp''s shared memory could not be read');
      Writeln('Reason: ' + StringToOem(SysErrorMessage(GetLastError)));
    end;
  except
    on E: Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;

end.
