// cdr2pdfviewer.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <windows.h>
#include <iostream>
#include <vector>

#include <Shlwapi.h>
#pragma comment( lib, "shlwapi.lib")

using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	if (argc == 1) {
		wcout << "Usage: " << argv[0] << " image.cdr" << endl;
		return 0;
	}

	std::vector<TCHAR> v(MAX_PATH);
	DWORD dwSize = GetModuleFileName(NULL, v.data(), MAX_PATH);
	std::string	strFileName(v.begin(),v.end());
	size_t pos = strFileName.find_last_of("\\");
	std::string strPathName(strFileName.begin(),strFileName.begin() + pos +1);
	//cout << "Path " << strPathName.c_str() << endl;

     //  Gets the temp path env string (no guarantee it's a valid path).
	std::vector<TCHAR> v2(MAX_PATH);
    dwSize = GetTempPath(MAX_PATH,          // length of the buffer
							v2.data()); // buffer for path 

    //  Generates a temporary file name. 
	std::vector<TCHAR> v3(MAX_PATH);
	dwSize = GetTempFileName( v2.data(), // directory for tmp files
                              TEXT("pdf"),     // temp file name prefix 
                              0,                // create unique name 
                              v3.data());  // buffer for name 
	wstring strTmp;
	strTmp.assign(v3.begin(),v3.end());
	pos = strTmp.find_last_of(L".");
	strTmp.replace(pos,strTmp.size()-pos,L".pdf");

	//strTmp.assign(strPathName.begin(),strPathName.end());
	//strTmp += L"temp.pdf";

	wstring strCmd;
	strCmd.append(L"\"");
	strCmd.append(strPathName.begin(),strPathName.end());
	strCmd.append(L"pyVM.exe\" -c \"from uniconvertor import uniconv_run; uniconv_run();\" \"");
	strCmd.append(argv[1]);
	strCmd.append(L"\" \"");
	strCmd.append(strTmp);
	strCmd.append(L"\"");

	string strCCmd(strCmd.begin(),strCmd.end());

	wstring strName(L"PATH");
	wstring strValue(strPathName.begin(),strPathName.end());
	strValue.append(L"DLLs");
	SetEnvironmentVariable(strName.c_str(),strValue.c_str());

	if (WinExec(strCCmd.c_str(),SW_HIDE)) {
		for(int i =0; i<10; i++) {
			Sleep(500);
			if(PathFileExists(strTmp.c_str())) break;
		}
		
		HINSTANCE hNewExe = ShellExecute(NULL,L"open",strTmp.c_str(),NULL,NULL,SW_SHOW);
		if ((int)hNewExe < 32) {
			wcout << L"Open " << strTmp.c_str() << L" Error Code:" << hNewExe << endl;
		}
		return TRUE;
	} else {
		DWORD dwOK = GetLastError();
		wcout << L"Error Run " << strCmd.c_str() << endl;
		return FALSE;
	}

	//getchar();

	return 0;
}