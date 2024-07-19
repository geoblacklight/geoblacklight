# frozen_string_literal: true

module Blacklight
  module Icons
    class IiifDragDropComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 480 250">
          	<g fill="none">
          		<title>#{title}</title>
          	<path fill="#E92428" d="M279.286838 122.603834C273.522507 124.570288 267.699145 126.385783 262.049687 128.640575 261.019031 129.051917 260.14792 131.247604 260.13755 132.626198 260.01151 148.464058 260.068946 164.302716 260.069744 180.141374 260.070541 195.580671 260.033846 211.019968 260.088091 226.459265 260.096068 228.638978 259.796923 230.164537 257.396581 231.039137 240.825527 237.080671 224.300741 243.25 207.755214 249.363419 207.536638 249.444888 207.244672 249.329073 206.658348 249.27476 206.539487 248.353035 206.299373 247.361022 206.299373 246.368211 206.312137 188.337859 206.341652 130.307508 206.37755 72.2771565 206.397493 39.985623 228.46245 11.5255591 259.789744 3.73482428 266.17151 2.14776358 272.78302 1.48722045 279.287635.3985623 279.287635 16.6389776 279.287635 32.8801917 279.287635 49.120607 277.606838 48.8370607 275.929231 48.5247604 274.243647 48.2723642 267.110427 47.2060703 260.77812 51.2827476 260.280342 58.3442492 259.669288 67.0071885 260.134359 75.7460064 260.134359 85.2060703 266.875897 82.9065495 273.081368 80.7899361 279.287635 78.672524 279.286838 93.3170927 279.286838 107.960863 279.286838 122.603834zM126.468262 85.5551118C126.544046 87.1900958 126.645356 88.3546326 126.645356 89.5183706 126.650142 134.635783 126.607863 179.753994 126.720342 224.870607 126.728319 228.095048 125.767066 229.432907 122.725356 230.519169 107.749744 235.868211 92.885812 241.531949 77.9700285 247.053514 76.6362393 247.547125 75.2210826 247.821086 73.5003989 248.290735 73.5003989 235.586262 73.5546439 223.226038 73.4900285 210.867412 73.3145299 177.083067 73.1326496 143.299521 72.8151567 109.516773 72.7840456 106.222843 73.7046154 104.781949 76.9537322 103.631789 92.2005698 98.2324281 107.310199 92.4432907 122.474872 86.8091054 123.672251 86.3642173 124.913504 86.0399361 126.468262 85.5551118z"/>
          		<path fill="#0F7CA8" d="M58.1506553 248.468051C40.6933333 242.018371 23.7816524 235.819489 6.94575499 229.422524 5.98609687 229.057508 5.09185185 227.078275 5.08626781 225.845847 4.98017094 201.230032 5.00968661 176.611821 5.01048433 151.995208 5.01207977 130.045527 5.01048433 108.094249 5.01048433 85.4944089 11.0899145 87.6693291 16.8598291 89.6805112 22.591453 91.7955272 33.3989744 95.7827476 44.1642165 99.8857827 54.9956695 103.805911 57.2524217 104.622204 58.3923647 105.535144 58.3867806 108.236422 58.2918519 154.14377 58.3133903 200.051118 58.3038177 245.959265 58.3038177 246.60623 58.2272365 247.253994 58.1506553 248.468051zM193.899601 248.503195C185.350427 245.396965 177.283875 242.486422 169.231681 239.535942 160.783818 236.440895 152.373447 233.242013 143.895271 230.235623 141.629744 229.432109 140.528091 228.484824 140.533675 225.790735 140.624615 179.639776 140.595897 133.488019 140.600684 87.336262 140.600684 86.9472843 140.689231 86.557508 140.808889 85.5854633 147.25208 87.9169329 153.550085 90.1373802 159.804217 92.4736422 170.106781 96.3210863 180.328775 100.396166 190.703932 104.033546 193.413789 104.983227 194.020057 106.214856 194.014473 108.838658 193.920342 152.46246 193.920342 196.086262 193.898803 239.711661 193.898803 242.357029 193.899601 245.003195 193.899601 248.503195z"/>
          		<path fill="#E92428" d="M88.9793732,83.764377 C76.5580627,83.514377 68.5585185,75.5958466 68.497094,63.0279553 C68.4476353,53.0902556 72.0038746,44.3162939 78.0242735,36.5678914 C85.5619373,26.8658147 94.8306553,19.9297125 107.381197,17.8298722 C121.457778,15.4752396 132.129687,26.1246006 131.343134,40.4345048 C130.286952,59.6317891 112.65812,79.1174121 95.6243875,82.7188498 C93.4338462,83.1821086 91.1954416,83.4209265 88.9793732,83.764377 Z"/>
          		<path fill="#0F7CA8" d="M136.040912 39.2444089C135.50245 22.5087859 149.169003 13.1876997 166.629516 19.6884984 184.445812 26.3210863 195.407293 39.6341853 198.225641 58.3602236 200.663476 74.5511182 191.088433 85.3226837 174.412877 83.0910543 154.540855 80.4313099 136.032137 59.2627796 136.040912 39.2444089zM.168319088 39.3841853C-.37014245 22.6485623 13.2964103 13.327476 30.7569231 19.8282748 48.5732194 26.4608626 59.5347009 39.7739617 62.3530484 58.5 64.7908832 74.6908946 55.2158405 85.4624601 38.5402849 83.2308307 18.6682621 80.5710863.16034188 59.4033546.168319088 39.3841853z"/>
          		<g fill="#9B9B9B" transform="translate(300 45)">
          			<path d="M179.997035,57.5990513 C179.997035,59.332356 179.360885,60.8323313 178.088584,62.0989771 L126.66086,113.298134 C125.38856,114.56478 123.881888,115.198103 122.140845,115.198103 C120.399803,115.198103 118.893131,114.56478 117.62083,113.298134 C116.34853,112.031488 115.71238,110.531513 115.71238,108.798208 L115.71238,83.1986296 L93.2127504,83.1986296 C86.6503585,83.1986296 80.7743392,83.3986263 75.5846925,83.7986197 C70.3950459,84.1986131 65.2388808,84.915268 60.1161973,85.9485843 C54.9935138,86.9819006 50.5404622,88.398544 46.7570423,90.1985143 C42.9736225,91.9984847 39.4413146,94.3151132 36.1601187,97.1483998 C32.8789227,99.9816865 30.2003954,103.348298 28.1245367,107.248233 C26.0486781,111.148169 24.4248209,115.76476 23.2529652,121.098005 C22.0811095,126.431251 21.4951817,132.464485 21.4951817,139.197707 C21.4951817,142.864313 21.6625896,146.964246 21.9974055,151.497505 C21.9974055,151.897498 22.0811095,152.680818 22.2485175,153.847466 C22.4159254,155.014113 22.4996294,155.897432 22.4996294,156.497422 C22.4996294,157.497406 22.2150359,158.330725 21.6458488,158.997381 C21.0766618,159.664037 20.2898444,159.997365 19.2853966,159.997365 C18.2139857,159.997365 17.2765011,159.430707 16.472943,158.297393 C16.0042007,157.697403 15.56894,156.964081 15.1671609,156.097429 C14.7653818,155.230776 14.3133803,154.230793 13.8111564,153.097478 C13.3089326,151.964164 12.9573759,151.164177 12.7564863,150.697518 C4.2521621,131.697831 0,116.664745 0,105.598261 C0,92.3318125 1.77452434,81.2319953 5.32357303,72.2988091 C16.1716086,45.432585 45.4680011,31.9994729 93.2127504,31.9994729 L115.71238,31.9994729 L115.71238,6.39989458 C115.71238,4.6665898 116.34853,3.16661451 117.62083,1.8999687 C118.893131,0.633322902 120.399803,0 122.140845,0 C123.881888,0 125.38856,0.633322902 126.66086,1.8999687 L178.088584,53.0991254 C179.360885,54.3657712 179.997035,55.8657465 179.997035,57.5990513 Z"/>
          		</g>
          	</g>
          </svg>
        SVG
      end

      def title
        key = "blacklight.icon.#{name}"
        t(key)
      end
    end
  end
end
