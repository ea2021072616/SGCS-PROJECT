<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        if (!Schema::hasColumn('roles', 'es_para_ccb')) {
            Schema::table('roles', function (Blueprint $table) {
                $table->boolean('es_para_ccb')->default(false)->after('descripcion');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (Schema::hasColumn('roles', 'es_para_ccb')) {
            Schema::table('roles', function (Blueprint $table) {
                $table->dropColumn('es_para_ccb');
            });
        }
    }
};
