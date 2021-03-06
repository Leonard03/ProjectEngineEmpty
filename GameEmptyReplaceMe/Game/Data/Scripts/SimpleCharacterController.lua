-- test script

SimpleCharacterController =
{

Externs =
{
	-- name, type, initial value
	{ "Speed", "Float", 10 },
	{ "SpeedRotation", "Float", 10 },
	{ "Animation", "Float", 1 },
};

OnLoad = function(this)
end,

OnPlay = function(this)
	-- math.randomseed( os.time() );

	-- initialize some local variables
	this.dir = Vector3(0,0,0);
	this.targetangle = 0;
end,

OnStop = function(this)
end,

OnTouch = function(this, action, id, x, y, pressure, size)
	-- LogInfo( "OnTouch " .. id .. "\n" );
end,

OnButtons = function(this, action, id)
	--LogInfo( "OnButtons " .. id .. "\n" );

	if( action == 2 ) then -- button held
		if( id == 1 ) then -- left
			this.dir.x = -1;
		end
		if( id == 2 ) then -- right
			this.dir.x = 1;
		end
		if( id == 3 ) then -- up
			this.dir.z = 1;
		end
		if( id == 4 ) then -- down
			this.dir.z = -1;
		end
	end
end,

Tick = function(this, deltaTime)
	
	-- todo - do these 2 lookups once in OnPlay?
	local animplayer = this.gameobject:GetAnimationPlayer();
	local transform = this.gameobject:GetTransform();

	local pos = transform:GetLocalPosition();
	local rot = transform:GetLocalRotation();

	-- play the correct animation and figure out facing direction based on input.
	if( this.dir.x ~= 0 or this.dir.z ~= 0 ) then
		this.targetangle = math.atan( this.dir.z, this.dir.x ) / math.pi * 180 - 90;
		this.Animation = 1;
	else
		this.Animation = 0;
	end

	-- move the player
	this.dir:Normalize(); -- avoid fast diagonals.
	pos.x = pos.x + this.dir.x * deltaTime * this.Speed;
	pos.z = pos.z + this.dir.z * deltaTime * this.Speed;

	-- rotate towards the target angle
	local anglediff = this.targetangle - rot.y;
	if( anglediff > 180 ) then anglediff = anglediff - 360;	end
	if( anglediff < -180 ) then anglediff = anglediff + 360; end
	--LogInfo( "rot.y " .. rot.y .. " " .. "this.targetangle " .. this.targetangle .. " " .. "anglediff " .. anglediff .. "\n" );
	rot.y = rot.y + anglediff * deltaTime * this.SpeedRotation;
	rot.y = rot.y % 360;

	-- set the new position and rotation values
	transform:SetLocalPosition( pos );
	transform:SetLocalRotation( rot );

	-- set the current animation
	if( animplayer ) then
		animplayer:SetCurrentAnimation( this.Animation );
	end

	-- zero out the input vector
	this.dir.x = 0;
	this.dir.z = 0;
end,

}