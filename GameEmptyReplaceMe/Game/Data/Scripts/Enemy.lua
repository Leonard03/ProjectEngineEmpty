-- test Enemy script, chases the player.

Enemy =
{

Externs =
{
	-- name, type, initial value
	{ "Speed", "Float", 1 },
	{ "ObjectChasing", "GameObject", "Player Object" },
};

OnPlay = function(this)
	--LogInfo( "OnPlay\n" );
end,

OnStop = function(this)
	--LogInfo( "OnStop\n" );
end,

OnTouch = function(this, action, id, x, y, pressure, size)
	--LogInfo( "OnTouch\n" );
end,

OnButtons = function(this, action, id)
	--LogInfo( "OnButtons\n" );
end,

Tick = function(this, deltaTime)
	--LogInfo( "Tick Start\n" );
	--LogInfo( "System time: " .. GetSystemTime() .. "\n" );

	local transform = this.gameobject:GetTransform();

	local pos = transform:GetLocalPosition();
	local posChasing = this.ObjectChasing:GetTransform():GetLocalPosition();

	posChasing.x = posChasing.x + math.cos( GetSystemTime() ) * 200;
	posChasing.y = posChasing.y + math.sin( GetSystemTime() ) * 200;
	
	local diff = posChasing:Sub( pos );
	diff = diff:Scale( deltaTime * this.Speed );
	
	pos = pos:Add( diff );

	transform:SetLocalPosition( pos );
	
	--obj = ComponentSystemManager:CreateGameObject( true );
	--ComponentSystemManager:DeleteGameObject( obj );
	--ComponentSystemManager:CopyGameObject( this.gameobject, "Dupe" );
	--obj = ComponentSystemManager:FindGameObjectByName( "Player Object" );

	--LogInfo( "Tick End\n" );
end,

}