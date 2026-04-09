import plotly.graph_objects as go
from plotly.subplots import make_subplots
import plotly.io as pio

B = "#1B4F8A"
T = "#5ECBC8"
A = "#F5A623"
C = "#FF977E"
BG = "#ECEEF2"
GRID = "#F0F0F0"

# rgba versions for opacity
B2 = "rgba(27,79,138,0.5)"
B3 = "rgba(27,79,138,0.3)"
A2 = "rgba(245,166,35,0.5)"
A3 = "rgba(245,166,35,0.3)"
T2 = "rgba(94,203,200,0.5)"
T3 = "rgba(94,203,200,0.3)"
C2 = "rgba(255,151,126,0.5)"
C3 = "rgba(255,151,126,0.3)"

quarters = ["Q1", "Q2", "Q3", "Q4"]
arr_q    = [1200, 1500, 620, 420]
comp_q   = [1100, 1000, 680, 570]
accel_q  = [98, 72, 28, 15]
churn_q  = [5, 15, 51, 22]

months      = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
monthly_arr = [320,380,450,490,470,340,290,270,310,360,400,420]

segments = ["Enterprise","Mid-Market","SMB"]
arr_seg  = [1930, 1270, 539]
comp_seg = [1080, 960, 480]

bands       = ["<80%","80-99%","100-119%","120%+"]
band_counts = [2, 5, 7, 4]
band_colors = [C, A, B, T]

accel_roi    = [27.65, 27.68, 37.63]
accel_colors = [B, B, T]

rep_names  = ["Olivia Brooks","James Harrington","Ryan Thompson",
              "Samantha Lee","Amy Chen","Aisha Johnson",
              "Kevin O'Brien","Brandon Cole"]
rep_attain = [127, 118, 104, 97, 91, 85, 80, 58]
rep_colors = [T, T, B, B, B, A, A, C]

hc_labels = ["Active (15)","Ramping (3)","Managers (3)"]
hc_values = [15, 3, 3]
hc_colors = [B, T, A]

signals = [
    ["Good",   "+104.3% org attainment despite H2 softening"],
    ["Plan",   "Aug -18% seasonal dip — build Q3 quota buffer"],
    ["Risk",   "$51K gap from SMB AE churn — add retention budget"],
    ["Keep",   "Accel $31/dollar — structure working, keep as-is"],
    ["Risk",   "SMB $2.81 comp efficiency — fix before hiring"],
    ["Review", "Top 20% concentration — quota calibration needed"],
]
signal_colors = [T, A, C, T, C, A]

fig = make_subplots(
    rows=4, cols=5,
    row_heights=[0.14, 0.26, 0.22, 0.28],
    column_widths=[0.20, 0.20, 0.20, 0.20, 0.20],
    specs=[
        [{"type":"bar"},{"type":"bar"},{"type":"bar"},{"type":"bar"},{"type":"indicator","rowspan":2}],
        [{"type":"scatter","colspan":3},None,None,{"type":"waterfall","colspan":2},None],
        [{"type":"bar"},{"type":"bar"},{"type":"bar"},{"type":"indicator"},None],
        [{"type":"bar","colspan":3},None,None,{"type":"pie"},{"type":"table"}],
    ],
    vertical_spacing=0.05,
    horizontal_spacing=0.04,
)

sparkline_colors = [
    [B, B, B2, B3],
    [A, A, A2, A3],
    [T, T, T2, T3],
    [C, C, C2, C3],
]

for col, y, colors in zip([1,2,3,4],[arr_q,comp_q,accel_q,churn_q],sparkline_colors):
    fig.add_trace(go.Bar(
        x=quarters, y=y,
        marker_color=colors,
        marker_line_width=0,
        showlegend=False,
    ), row=1, col=col)

fig.add_trace(go.Indicator(
    mode="gauge+number",
    value=104.3,
    number={"suffix":"%","font":{"size":22,"color":B}},
    gauge={
        "axis":{"range":[0,110],"tickvals":[0,50,100],"ticktext":["0%","50%","100%"]},
        "bar":{"color":B},
        "bgcolor":"white",
        "borderwidth":0,
        "threshold":{"line":{"color":A,"width":3},"thickness":0.85,"value":100},
        "steps":[
            {"range":[0,80],"color":"rgba(255,151,126,0.13)"},
            {"range":[80,100],"color":"rgba(245,166,35,0.13)"},
            {"range":[100,110],"color":"rgba(94,203,200,0.13)"},
        ],
    },
    title={"text":"Org Attainment<br><span style='font-size:10px;color:#888'>Exceeded quota by 4.3%</span>","font":{"size":12,"color":"#444"}},
), row=1, col=5)

fig.add_trace(go.Scatter(
    x=months, y=monthly_arr,
    mode="lines+markers+text",
    line={"color":B,"width":2.5},
    fill="tozeroy",
    fillcolor="rgba(27,79,138,0.1)",
    marker={"color":[C if m=="Aug" else B for m in months],
            "size":[10 if m in ["Apr","Aug"] else 5 for m in months]},
    text=["$"+str(v)+"K" for v in monthly_arr],
    textposition=["top center" if v>=400 else "bottom center" for v in monthly_arr],
    textfont={"size":9,"color":[C if m=="Aug" else "#555" for m in months]},
    showlegend=False,
), row=2, col=1)

fig.add_trace(go.Waterfall(
    x=["Base","Variable","Accel.","Churn","Total"],
    y=[2100, 820, 213, -130, 3350],
    measure=["relative","relative","relative","relative","total"],
    connector={"line":{"color":"#ccc","width":1}},
    increasing={"marker":{"color":T}},
    decreasing={"marker":{"color":C}},
    totals={"marker":{"color":B}},
    text=["$2.1M","+$820K","+$213K","-$130K","$3.35M"],
    textposition="outside",
    textfont={"size":9},
    showlegend=False,
), row=2, col=4)

fig.add_trace(go.Bar(x=segments, y=arr_seg, name="ARR", marker_color=B,
    text=["$1.93M","$1.27M","$539K"], textposition="outside", textfont={"size":9},
), row=3, col=1)
fig.add_trace(go.Bar(x=segments, y=comp_seg, name="Comp Cost", marker_color=A,
    text=["$1.08M","$960K","$480K"], textposition="outside", textfont={"size":9},
), row=3, col=1)

fig.add_trace(go.Bar(
    x=bands, y=band_counts,
    marker_color=band_colors,
    text=band_counts,
    textposition="outside",
    textfont={"size":11},
    showlegend=False,
), row=3, col=2)

fig.add_trace(go.Bar(
    x=segments, y=accel_roi,
    marker_color=accel_colors,
    text=["$27.65","$27.68","$37.63"],
    textposition="outside", textfont={"size":9},
    showlegend=False,
), row=3, col=3)

fig.add_trace(go.Indicator(
    mode="gauge+number",
    value=4.47,
    number={"prefix":"$","font":{"size":20,"color":T}},
    gauge={
        "axis":{"range":[0,5],"tickvals":[0,2.5,5],"ticktext":["$0","$2.5","$5"]},
        "bar":{"color":T},
        "bgcolor":"white",
        "borderwidth":0,
        "steps":[{"range":[0,5],"color":"rgba(94,203,200,0.07)"}],
    },
    title={"text":"Comp Efficiency<br><span style='font-size:9px;color:#888'>ARR per $1 comp · Enterprise</span>","font":{"size":11,"color":"#444"}},
), row=3, col=4)

fig.add_trace(go.Bar(
    y=rep_names, x=rep_attain,
    orientation="h",
    marker_color=rep_colors,
    text=[str(v)+"%" for v in rep_attain],
    textposition="outside",
    textfont={"size":9},
    showlegend=False,
), row=4, col=1)
fig.add_vline(x=100, line_dash="dash", line_color=A, line_width=1.5, row=4, col=1)

fig.add_trace(go.Pie(
    labels=hc_labels, values=hc_values,
    hole=0.65,
    marker={"colors":hc_colors},
    textinfo="none",
    showlegend=True,
), row=4, col=4)

fig.add_trace(go.Table(
    header=dict(
        values=["<b>Signal</b>","<b>2026 Planning Finding</b>"],
        fill_color=B,
        font=dict(color="white", size=10),
        align="left", height=28,
    ),
    cells=dict(
        values=[[s[0] for s in signals],[s[1] for s in signals]],
        fill_color=[signal_colors,["white"]*6],
        font=dict(color=[["white"]*6,["#333"]*6], size=9),
        align="left", height=24,
    ),
), row=4, col=5)

fig.update_layout(
    title=dict(
        text="<b>Veltora Inc. — Sales Compensation Dashboard · FY 2025</b><br>"
             "<span style='font-size:12px;color:#888'>Executive Summary · Full Year Performance · RevOps Team · Austin, TX · Series B</span>",
        font=dict(size=20, color="#111"),
        x=0.01, y=0.99, xanchor="left", yanchor="top",
    ),
    paper_bgcolor=BG,
    plot_bgcolor="white",
    height=1200,
    margin=dict(l=40, r=40, t=100, b=40),
    barmode="group",
    font=dict(family="Segoe UI, Arial", size=10, color="#333"),
    legend=dict(orientation="h", x=0.0, y=-0.02, font=dict(size=9)),
)

fig.update_xaxes(showgrid=False, zeroline=False, tickfont=dict(size=8))
fig.update_yaxes(gridcolor=GRID, zeroline=False, tickfont=dict(size=8))

for col in [1,2,3,4]:
    fig.update_yaxes(showticklabels=False, showgrid=False, row=1, col=col)

fig.update_yaxes(tickprefix="$", ticksuffix="K", row=2, col=1)
fig.update_xaxes(range=[0,145], ticksuffix="%", row=4, col=1)
fig.update_yaxes(autorange="reversed", row=4, col=1)

pio.write_html(fig, file="veltora_dashboard.html", full_html=True,
               include_plotlyjs=True, auto_open=True)

print("Dashboard saved to veltora_dashboard.html")
