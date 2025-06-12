Shader "Custom/P4_C4"
{
    Properties
    {
        _Albedo ("AlbedoEmissionRatio", Range(0, 1)) = 0
        _Color ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;

        struct Input
        {
            float4 color : COLOR ;
        };


        // float : 32비트, 좌표계, 물리 계산
        // half : 16비트, 일반적인 그래픽 계산
        // fixed : 10비트, 색상 계산

        fixed4 _Color;
        fixed _Albedo;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 색상 연산 : 각 요소끼리 연산
            // + 항상 [0, 1] 사이의 값을 가짐
            float3 c1 = float3(1, 0, 0) + float3(1, 1, 0);              // == float3(1, 1, 0)
            float3 c2 = float3(0.5, 0.5, 0.5) * float3(0.5, 0.5, 0.5);  // == float3(0.25, 0.25, 0.25)
            
            // 한 자리 연산은 모든 자릿수에 대응
            float3 c3 = float3(1, 0.7, 0.3) - 0.5;                      // == float3(0.5, 0.2, 0)

            // r, g, b 는 0, 1, 2번째 Element를 뜻함
            float2 c4 = c3.gr;                                          // == float2(0.2, 0.5)
            float3 c5 = float3(0, c4.rg);                               // == float3(0, 0.2, 0.5)

            o.Albedo = _Color.rgb * (1 - _Albedo);  // Albedo : 빛의 영향을 받음
            o.Emission = _Color.rgb * _Albedo;      // Emission : 빛의 영향을 받지 않음
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
