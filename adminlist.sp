#pragma semicolon 1

#include <sourcemod>

#define VERSION "1.0"

public Plugin:myinfo =
{
	name = "[NEVERGO] Admin List",
	author = "Lawyn",
	description = "",
	version = VERSION,
	url = "https://nevergo.ro"
};

public OnPluginStart()
{
	RegConsoleCmd( "sm_admins", Command_Admins);
	RegConsoleCmd( "sm_vips", Command_Vips);
	
	CreateConVar( "sm_adminslist_version", VERSION, "Version of admin menu.", FCVAR_NOTIFY );
}

public Action:Command_Admins( Client, Args )
{
	if( Client )
	{
		decl Handle:Menu, String:Buffer[MAX_NAME_LENGTH];
		Menu = CreateMenu( HandleAdminList );
		
		SetMenuTitle( Menu, "Lista Adminilor" );
		
		for( new i = 1; i <= MaxClients; i++ )
		{
			if( IsClientInGame(i) )
			{
				if( CheckCommandAccess( i, "", ADMFLAG_ROOT  ) )
				{
					Format(Buffer, sizeof(Buffer), "%N [Owner]", i);
					AddMenuItem( Menu, "", Buffer );
				}
				else if( CheckCommandAccess( i, "", ADMFLAG_UNBAN  ) )
				{
					Format(Buffer, sizeof(Buffer), "%N [Co-Owner]", i);
					AddMenuItem( Menu, "", Buffer );
				}
				else if( CheckCommandAccess( i, "", ADMFLAG_RESERVATION  ) )
				{
					Format(Buffer, sizeof(Buffer), "%N [Operator]", i);
					AddMenuItem( Menu, "", Buffer );
				}
				else if( CheckCommandAccess( i, "", ADMFLAG_BAN  ) )
				{
					Format(Buffer, sizeof(Buffer), "%N [Moderator]", i);
					AddMenuItem( Menu, "", Buffer );
				}
				else if( CheckCommandAccess( i, "", ADMFLAG_VOTE ) )
				{
					Format(Buffer, sizeof(Buffer), "%N [Admin]", i);
					AddMenuItem( Menu, "", Buffer );
				}
				else if( CheckCommandAccess( i, "", ADMFLAG_SLAY  ) )
				{
					Format(Buffer, sizeof(Buffer), "%N [Helper]", i);
					AddMenuItem( Menu, "", Buffer );
				}
			}
		}
		
		if( GetMenuItemCount( Menu ) > 0 )
		{
			DisplayMenu( Menu, Client, 30 );
		}
		else
		{	
			AddMenuItem( Menu, "", "Nu sunt admini online" );
			DisplayMenu( Menu, Client, 30 );
		}
	}
	
	return Plugin_Handled;
}

public HandleAdminList(Handle:hMenu, MenuAction:HandleAction, Client, Parameter)
{
	if(HandleAction == MenuAction_End)
	{
		CloseHandle( hMenu );
	}
}

public Action Command_Vips(client, args)
{
	decl String:Buffer[MAX_NAME_LENGTH];
	Menu menuv = new Menu(menuv_call);
	menuv.SetTitle("Lista Vip-urilor");
	for( new i = 1; i <= MaxClients; i++ )
	{
		if(IsClientInGame(i))
		{
			if( CheckCommandAccess( i, "", ADMFLAG_CUSTOM1  ))
			{
				Format(Buffer, sizeof(Buffer), "%N [VIP]", i);
				menuv.AddItem("", Buffer, ITEMDRAW_DISABLED);
			}
		}
	}
	if(menuv.ItemCount > 0)
	{
		menuv.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		menuv.AddItem("", "Nu sunt vip-uri online pe server");
		menuv.Display(client, MENU_TIME_FOREVER);
	}
}

public int menuv_call(Menu menuv, MenuAction action, client, param2)
{
	switch(action)
	{
		case MenuAction_End:
		{
			delete menuv;
		}
	}
}
