<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Backfill NULL rol_en_ccb to a sensible default 'Miembro'
        DB::table('miembros_ccb')
            ->whereNull('rol_en_ccb')
            ->update(['rol_en_ccb' => 'Miembro']);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // No-op: we won't revert text values to NULL automatically
    }
};
