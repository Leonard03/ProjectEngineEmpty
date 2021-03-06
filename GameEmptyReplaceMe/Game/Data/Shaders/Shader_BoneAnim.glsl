#ifdef WIN32
#define lowp
#define mediump
#else
precision mediump float;
#endif

#ifdef PassMain

    #include <Include/WSVaryings.glsl>

#if ReceiveShadows
    varying lowp vec4 v_ShadowPos;

    uniform mat4 u_ShadowLightWVPT;
    uniform sampler2D u_ShadowTexture;
#endif //ReceiveShadows

#ifdef VertexShader

    attribute vec4 a_Position;
    attribute vec3 a_Normal;

    uniform mat4 u_World;
    uniform mat4 u_WorldViewProj;

    #include <Include/Bone_AttribsAndUniforms.glsl>
    #include <Include/Bone_Functions.glsl>
    #include <Include/WSVaryings_Functions.glsl>

    void main()
    {
        vec4 pos;
        vec3 normal;
    
        ApplyBoneInfluencesToPositionAndNormalAttributes( a_Position, a_Normal, pos, normal );
        SetWSPositionAndNormalVaryings( u_World, pos, normal );

        gl_Position = u_WorldViewProj * pos;
#if ReceiveShadows
        v_ShadowPos = u_ShadowLightWVPT * pos;
#endif //ReceiveShadows
    }

#endif //VertexShader

#ifdef FragmentShader

    uniform vec3 u_WSCameraPos;
    uniform float u_Shininess;

    #define NUM_DIR_LIGHTS 1
    #include <Include/Light_Uniforms.glsl>
    #include <Include/Light_Functions.glsl>

    void main()
    {
        // Get the textures color.
        vec4 materialColor = vec4( 1, 1, 1, 1 ); //texture2D( u_TextureColor, v_UVCoord );

#ifdef Deferred

	    gl_FragData[0].rgb = materialColor.rgb;
	    gl_FragData[0].a = 1;
	    gl_FragData[1].xyz = v_WSPosition.xyz;
	    gl_FragData[1].a = u_Shininess;
	    gl_FragData[2].xyz = normalize( v_WSNormal );
	    gl_FragData[2].a = 1;

#else

        // Calculate the normal vector in world space. normalized again since interpolation can/will distort it.
        //   TODO: handle normal maps.
        vec3 WSnormal = normalize( v_WSNormal );

        // Whether fragment is in shadow or not, returns 0.0 if it is, 1.0 if not.
        float shadowperc = CalculateShadowPercentage( v_ShadowPos );

        // Accumulate ambient, diffuse and specular color for all lights.
        vec3 finalambient = vec3(0,0,0);
        vec3 finaldiffuse = vec3(0,0,0);
        vec3 finalspecular = vec3(0,0,0);

        DirLightContribution( v_WSPosition.xyz, u_WSCameraPos, WSnormal, u_Shininess, finalambient, finaldiffuse, finalspecular );
        finaldiffuse *= shadowperc;

        // Add in each light, one by one. // finaldiffuse, finalspecular are inout.
#if NUM_LIGHTS > 0
        for( int i=0; i<NUM_LIGHTS; i++ )
            PointLightContribution( u_LightPos[i], u_LightColor[i], u_LightAttenuation[i], v_WSPosition.xyz, u_WSCameraPos, WSnormal, u_Shininess, finalambient, finaldiffuse, finalspecular );
#endif

        // Mix the texture color with the light color.
        vec3 ambdiff = /*materialColor.rgb * v_Color.rgb * */( finalambient + finaldiffuse );
        vec3 spec = /*u_TextureSpecColor.rgb **/ finalspecular;

        // Calculate final color.
        gl_FragColor.rgb = ( ambdiff + spec );
        //gl_FragColor.rgb = WSnormal;
        gl_FragColor.a = 1.0; //materialColor.a

#endif //Deferred
    }

#endif

#endif //PassMain

#ifdef PassShadowCastRGB

    #include <Include/WSVaryings.glsl>

#ifdef VertexShader

    attribute vec4 a_Position;
    attribute vec3 a_Normal;

    uniform mat4 u_World;
    uniform mat4 u_WorldViewProj;

    #include <Include/Bone_AttribsAndUniforms.glsl>
    #include <Include/Bone_Functions.glsl>
    #include <Include/WSVaryings_Functions.glsl>

    void main()
    {
        vec4 pos;
        vec3 normal;
    
        ApplyBoneInfluencesToPositionAndNormalAttributes( a_Position, a_Normal, pos, normal );
        SetWSPositionAndNormalVaryings( u_World, pos, normal );

        gl_Position = u_WorldViewProj * pos;
    }

#endif //VertexShader

#ifdef FragmentShader

    void main()
    {
#if 1
        gl_FragColor = vec4(1,1,1,1);
#else
        float value = gl_FragCoord.z;

        // Pack depth float value into RGBA, for ES 2.0 where depth textures don't exist.
        const vec4 bitSh = vec4( 256.0*256.0*256.0, 256.0*256.0, 256.0, 1.0 );
        const vec4 bitMsk = vec4( 0.0, 1.0/256.0, 1.0/256.0, 1.0/256.0 );
        vec4 res = fract( value * bitSh );
        res -= res.xxyz * bitMsk;

        gl_FragColor = res;
#endif
    }

#endif //Fragment Shader

#endif //PassShadowCastRGB
