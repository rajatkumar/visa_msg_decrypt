module.exports = function(grunt) {
    var config;
    config = {
        coffeelint: {
            app: ['src/**/*.coffee'],
            options: {
                arrowspacing: {
                    level: 'error'
                },
                colon_asignment_spacing: {
                    level: 'error',
                    left: 0,
                    right: 1
                },
                line_endings: {
                    level: 'error',
                    value: 'unix'
                },
                max_line_length: {
                    value: 240
                },
                newlines_after_classes: {
                    level: 'error',
                    value: 2
                },
                no_standalone_at: {
                    level: 'error'
                },
                space_operators: {
                    level: 'error'
                }
            }
        },
        coffee: {
            compile: {
                expand: true,
                cwd: 'src',
                src: '**/*.coffee',
                dest: 'js',
                ext: '.js',
                options: {
                    sourceMap: true
                }
            }
        },
        mochaTest: {
            test: {
                options: {
                    require: 'coffee-coverage/register-istanbul',
                    compilers: 'coffee-script/register',
                    bail: true,
                    colors: true,
                    reporter: 'list',
                    timeout: 10000
                },
                src: ['test/**/*.coffee']
            }
        },
        makeReport: {
            src: 'coverage/**/*.json',
            options: {
                type: 'lcov',
                dir: 'coverage/',
                print: 'detail'
            }
        },
        clean: ['coverage', 'js']
    };
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-coffeelint');
    grunt.loadNpmTasks('grunt-mocha-test');
    grunt.loadNpmTasks('grunt-istanbul');
    grunt.loadNpmTasks('grunt-contrib-clean');

    //grunt.loadTasks('tasks');

    grunt.registerTask('compile', ['coffeelint', 'coffee']);
    grunt.registerTask('mocha', ['clean', 'compile', 'mochaTest']);
    grunt.registerTask('coverage', ['makeReport']);

    grunt.initConfig(config);
};
