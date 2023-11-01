Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A001B7DE57B
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Nov 2023 18:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbjKARni (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Nov 2023 13:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbjKARnh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 13:43:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8E7FD;
        Wed,  1 Nov 2023 10:43:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 651EA21A3C;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1698860606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ya9wJTGsFqDmrtfE98xEkceWVj8NxoKXjlXee7fCXHk=;
        b=TZ+XPzFY4Vyhmx2AHzQcFSnZEkM66R9XfED6vYM7vSv2r5JOfgF6o/Z/lt17I0crjK3ulN
        LEayriQw3WhGE4zUyFdWBpMbZdJvmCP06FLcca9hcmh2C/DQcNpF5hp0GXC7JgbQld2Gjd
        ru40Dtdm7qBP/AsvkgIzlzDdUoQscLE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1698860606;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ya9wJTGsFqDmrtfE98xEkceWVj8NxoKXjlXee7fCXHk=;
        b=uxJNggySy8ekHAQPQVaPjpwYgo2Qp3zhNi5polo480ESSTZcEaDutwdBy3PfAZjEAOwQU3
        9V8ksO0eqirVhjCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 56E5D13ACD;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wPF7FD6OQmUkYQAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 01 Nov 2023 17:43:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C31F1A06E3; Wed,  1 Nov 2023 18:43:25 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Christian Brauner <brauner@kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        <linux-xfs@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v3] block: Add config option to not allow writing to mounted devices
Date:   Wed,  1 Nov 2023 18:43:05 +0100
Message-Id: <20231101173542.23597-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2418; i=jack@suse.cz; h=from:subject:message-id; bh=1CPeOjIzxmuXXRhktXLeezFp4+qQoxcJSuu8Y3wwCmc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBlQo4pnByYh0U+fZrONq8ZHxES7U02/GLlSLSZ+aQk kEWsrJuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZUKOKQAKCRCcnaoHP2RA2TgmB/ 0cReL8fGG4/IP+beq6WW7mhrPi8wl/zMnzhXmWju0z0LHb5bXcTO1qOaqL7g8gXpfB0wadwnW1RpKD 21zkcu8klR2FJ6Cz8lIqBaWtyrF1EwXfk52KB+1djdvSUnuhqbo2S/PPnmxaZ+GX6g4gfX0Iv6wxPF s6W3bQL3w4f+3h/hYH8SpHWvJ7comZLO5haYHpx5SWCeObf+c0oGwCORAaV8AhD+wxbsnsxkt5HANY 0zS0AdN4MEOb+I5Zb0lSsklu9Qes5YjRw2p/qDjg8myFX0ggTV0cnWNq271hUP+ObQIs9FiRpMzmCb d144OOJPQtcxSMIvHbWYTQpqrQIzad
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello!

This is the third version of the patches to add config option to not allow
writing to mounted block devices. The new API for block device opening has been
merged so hopefully this patchset can progress towards being merged. We face
some issues with necessary btrfs changes (review bandwidth) so this series is
modified to enable restricting of writes for all other filesystems. Once btrfs
can merge necessary device scanning changes, enabling the support for
restricting writes for it is trivial.

For motivation why restricting writes to mounted block devices is interesting
see patch 3/7. I've been testing the patches more extensively and I've found
couple of things that get broken by disallowing writes to mounted block
devices:

1) "mount -o loop" gets broken because util-linux keeps the loop device open
   read-write when attempting to mount it. Hopefully fixable within util-linux.
2) resize2fs online resizing gets broken because it tries to open the block
   device read-write only to call resizing ioctl. Trivial to fix within
   e2fsprogs.
3) Online e2label will break because it directly writes to the ext2/3/4
   superblock while the FS is mounted to set the new label.  Ext4 driver
   will have to implement the SETFSLABEL ioctl() and e2label will have
   to use it, matching what happens for online labelling of btrfs and
   xfs.

Likely there will be other breakage I didn't find yet but overall the breakage
looks minor enough that the option might be useful. Definitely good enough
for syzbot fuzzing and likely good enough for hardening of systems with
more tightened security.

This patch set is based on the VFS tree as of yesterday.

Changes since v2:
* Rebased on top of current VFS tree
* Added missing conversion of bcachefs to new bdev opening API
* Added patch to drop old bdev opening API
* Dropped support for restricting writes to btrfs to avoid patch dependencies
  and unblock merging of the patches

Changes since v1:
* Added kernel cmdline argument to toggle whether writing to mounted block
  devices is allowed or not
* Fixed handling of partitions
* Limit write blocking only to devices open with explicit BLK_OPEN_BLOCK_WRITES
  flag

								Honza

Previous versions:
Link: https://lore.kernel.org/all/20230612161614.10302-1-jack@suse.cz #v1
Link: https://lore.kernel.org/all/20230704122727.17096-1-jack@suse.cz #v2
