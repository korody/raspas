if (typeof Object.create !== 'function') {
    Object.create = function(obj) {
        function F() {}
        F.prototype = obj;
        return new F();
    };
}

(function($, window, document, undefined) {

    var Validator = {
        init: function(options, elem) {
            var self = this;

            self.elem = elem;
            self.$elem = $(elem);

            self.url = options.url;

            if (options.attribute) {
                self.attribute = options.attribute;
            } else {
                self.attribute = self.elem.getAttribute('name');
            }

            self.options = $.extend({}, $.fn.remoteValidate.options, options);

            self.errorsContainer = $(this.options.errorsContainer, {
                class: this.options.errorsContainerClass
            });
            self.$elem.after(self.errorsContainer);

            self.validate();
        },

        validate: function() {
            var self = this;

            self.$elem.on(self.options.event, function() {
                var value = self.$elem.val();

                if (!value) {
                    self.errorsContainer.html('');
                    self.attributeValue = null;
                    return;
                }

                if (value && value !== self.attributeValue) {
                    self.attributeValue = value;

                    self.queryServer()
                        .success(function() {
                            self.display([]);

                            if (typeof self.options.onComplete === 'function') {
                                self.options.onComplete.apply(self.elem, arguments);
                            }
                        })
                        .error(function(results) {
                            var errors = self.buildFrag($.parseJSON(results.responseText).errors);
                            self.display(errors);

                            if (typeof self.options.onError === 'function') {
                                self.options.onError.apply(self.elem, arguments);
                            }
                        });
                }
            });
        },

        display: function(errors) {
            var self = this;

            if (self.options.transition === 'none' || !self.options.transition) {
                self.errorsContainer.html(errors);
            } else {
                self.errorsContainer[self.options.transition](self.options.transitionDuration, function() {
                    $(this)
                        .html(errors)[self.options.transition](self.options.transitionDuration);
                });
            }
        },

        queryServer: function() {
            var self = this;

            return $.get(self.url, {
                attribute: self.attribute,
                format: 'json',
                value: self.$elem.val()
            });
        },

        buildFrag: function(errors) {
            var self = this;

            return $.map(errors, function(error) {
                return $(self.options.wrapEachWith, {
                        class: self.options.errorClass
                    })
                    .append(error);
            });
        }
    };

    $.fn.remoteValidate = function(options) {
        return this.each(function() {
            var validator = Object.create(Validator);
            validator.init(options, this);

            $.data(this, 'remoteValidate', validator);
        });
    };

    $.fn.remoteValidate.options = {
        wrapEachWith: '<p></p>',
        errorClass: 'error-message',
        event: 'blur',
        onComplete: null,
        onError: null,
        errorsContainer: '<div></div>',
        errorsContainerClass: 'errors-container',
        transition: false,
        transitionDuration: 0,
    };

})(jQuery, window, document);
