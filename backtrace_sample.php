<?php

/**
 * debug_backtrace() の結果をスリム化する.
 *
 * @param array $backtrace_array debug_backtrace() の返り値.
 * @param int $trace_level トレースする深さ.
 * @return array スリム化したトレース情報. 
 */
function backtrace( array $backtrace_array, $trace_level=1 ) {
    $array_count = count($backtrace_array);
    $trace_level = ($array_count>=$trace_level) ? $trace_level : $array_count;
    for($i=0; $i<$trace_level; $i++) {
        if( isset($backtrace_array[$i]['file']) ) {
            $traces[$i] = $backtrace_array[$i]['file'].':'.$backtrace_array[$i]['line'];
        } else {
            $traces[$i] = $backtrace_array[$i]['class'].'::'.$backtrace_array[$i]['function'];
        }
    }
    return $traces;
}

/**
 * デバッグ表示.
 *
 * @param mixed $var 表示したい変数.
 * @param int $trace_level トレースする深さ.
 * @param string $style tracer() で表示した時の HTML スタイル.
 */
function tracer( $var, $trace_level=1, $style='color:#000; background-color:#CCC' ) {
    $trace = backtrace( debug_backtrace(), $trace_level );
    echo "<pre style=\"$style\">";
    foreach( $trace as $info )
    {
        echo $info.PHP_EOL;
    }
    var_dump( $var );
    echo "</pre>";
}

 $numbers = [1,2,3,4,5,6,7,8,9];
    tracer($numbers,10);
