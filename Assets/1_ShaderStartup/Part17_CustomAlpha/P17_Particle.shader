Shader "Custom/P17/P17_Particle"
{
    Properties
    {
        // _TintColor: 전체 색상을 제어
        _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("SrcBlend Mode", Float)=5
        [Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("DstBlend Mode", Float)=10
    }
    SubShader
    {
        // 내장 프로젝터에 반응하지 않도록 설정
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" }
        ZWrite Off 
        Cull Off
        Blend [_SrcBlend] [_DstBlend]

        CGPROGRAM
        // 기본적으로 생성되는 추가 쉐이더들 생성되지 않도록 함
        #pragma surface surf nolight keepalpha noforwardadd nolightmap noambient novertexlights noshadow

        sampler2D _MainTex;
        float4 _TintColor;

        struct Input
        {
            float2 uv_MainTex;
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            c = c * 2 * _TintColor * IN.color;
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten){
            return float4 (0,0,0,s.Alpha);
        }

        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
