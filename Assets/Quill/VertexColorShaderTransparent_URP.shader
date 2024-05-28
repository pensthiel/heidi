Shader "Unlit/VertexColorShaderTransparent_URP"
{
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 100

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float4 vertColor : COLOR;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 vertColor : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertColor = v.vertColor;
                UNITY_TRANSFER_FOG(o,o.vertex);

                float3 normal =  UnityObjectToWorldNormal(v.normal);
                float t = max(0, dot(normal, _WorldSpaceLightPos0.xyz));
                float4 diff = _LightColor0 * t;
                o.vertColor *= diff;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = i.vertColor;

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
