local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function get_namespace()
  local file_path = vim.fn.expand("%:p:h")
  local namespace = file_path:gsub("^.*/app/", "App\\"):gsub("/", "\\")
  return namespace
end

return {
  s("class", fmt([[
<?php

namespace {};

class {}
{{
    {}
}}
]], {
    f(get_namespace, {}),
    i(1, "ClassName"),
    i(0)
  })),

  s("trait", fmt([[
<?php

namespace {};

trait {}
{{
    {}
}}
]], {
    f(get_namespace, {}),
    i(1, "TraitName"),
    i(0)
  })),

  s("interface", fmt([[
<?php

namespace {};

interface {}
{{
    {}
}}
]], {
    f(get_namespace, {}),
    i(1, "InterfaceName"),
    i(0)
  })),

  s("method", fmt([[
public function {}({})
{{
    {}
}}
]], {
    i(1, "methodName"),
    i(2),
    i(0)
  })),

  s("construct", fmt([[
public function __construct({})
{{
    {}
}}
]], {
    i(1),
    i(0)
  })),

  s("test", fmt([[
public function test_{}(): void
{{
    {}
}}
]], {
    i(1, "it_does_something"),
    i(0)
  })),

  s("pest", fmt([[
it('{}', function () {{
    {}
}});
]], {
    i(1, "does something"),
    i(0)
  })),

  s("route", fmt([[
Route::{}('{}', [{}::class, '{}']);
]], {
    i(1, "get"),
    i(2, "/path"),
    i(3, "Controller"),
    i(4, "method")
  })),

  s("controller", fmt([[
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class {} extends Controller
{{
    public function {}(Request $request)
    {{
        {}
    }}
}}
]], {
    i(1, "ControllerName"),
    i(2, "index"),
    i(0)
  })),

  s("model", fmt([[
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class {} extends Model
{{
    protected $fillable = [
        {}
    ];

    {}
}}
]], {
    i(1, "ModelName"),
    i(2, "'field'"),
    i(0)
  })),

  s("migration", fmt([[
public function up(): void
{{
    Schema::create('{}', function (Blueprint $table) {{
        $table->id();
        {}
        $table->timestamps();
    }});
}}

public function down(): void
{{
    Schema::dropIfExists('{}');
}}
]], {
    i(1, "table_name"),
    i(2),
    f(function(args) return args[1][1] end, {1})
  })),

  s("factory", fmt([[
<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class {} extends Factory
{{
    public function definition(): array
    {{
        return [
            {}
        ];
    }}
}}
]], {
    i(1, "ModelFactory"),
    i(0)
  })),

  s("resource", fmt([[
<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class {} extends JsonResource
{{
    public function toArray($request): array
    {{
        return [
            {}
        ];
    }}
}}
]], {
    i(1, "ResourceName"),
    i(0)
  })),

  s("request", fmt([[
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class {} extends FormRequest
{{
    public function authorize(): bool
    {{
        return {};
    }}

    public function rules(): array
    {{
        return [
            {}
        ];
    }}
}}
]], {
    i(1, "RequestName"),
    i(2, "true"),
    i(0)
  })),

  s("job", fmt([[
<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class {} implements ShouldQueue
{{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct()
    {{
        {}
    }}

    public function handle(): void
    {{
        {}
    }}
}}
]], {
    i(1, "JobName"),
    i(2),
    i(0)
  })),

  s("event", fmt([[
<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class {}
{{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct()
    {{
        {}
    }}
}}
]], {
    i(1, "EventName"),
    i(0)
  })),

  s("listener", fmt([[
<?php

namespace App\Listeners;

use App\Events\{};
use Illuminate\Contracts\Queue\ShouldQueue;

class {} implements ShouldQueue
{{
    public function __construct()
    {{
        {}
    }}

    public function handle({} $event): void
    {{
        {}
    }}
}}
]], {
    i(1, "EventName"),
    i(2, "ListenerName"),
    i(3),
    f(function(args) return args[1][1] end, {1}),
    i(0)
  })),

  s("middleware", fmt([[
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class {}
{{
    public function handle(Request $request, Closure $next)
    {{
        {}

        return $next($request);
    }}
}}
]], {
    i(1, "MiddlewareName"),
    i(0)
  })),

  s("command", fmt([[
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class {} extends Command
{{
    protected $signature = '{}';
    protected $description = '{}';

    public function handle(): int
    {{
        {}

        return 0;
    }}
}}
]], {
    i(1, "CommandName"),
    i(2, "command:name"),
    i(3, "Command description"),
    i(0)
  })),
}
