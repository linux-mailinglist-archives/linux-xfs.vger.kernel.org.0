Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A262F7D9E02
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Oct 2023 18:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjJ0QaI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Oct 2023 12:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjJ0QaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 12:30:07 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D759C
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 09:30:04 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwPik-003RJj-RF; Fri, 27 Oct 2023 16:30:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: Anthony Iliopoulos <ailiop@suse.com>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <871qdgccs5.fsf@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <20231027154505.GL3195650@frogsfrogsfrogs> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698424120818606
          (code B ref 1054644); Fri, 27 Oct 2023 16:30:01 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 16:28:40 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Bayes: score:0.0000 Tokens: new, 26; hammy, 150; neutral, 63; spammy,
        0. spammytokens: hammytokens:0.000-+--UD:kernel.org, 0.000-+--cc'ed,
        0.000-+--H*r:ECDSA, 0.000-+--sk:git.sav, 0.000-+--sk:gitsav
Received: from smtp-out2.suse.de ([195.135.220.29]:58938)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ailiop@suse.com>)
        id 1qwPhO-003Qws-3D
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 16:28:40 +0000
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8D5D31F898;
        Fri, 27 Oct 2023 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1698423574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TXiziHB9+Vg0DlIoA0EAULe3ps4V7AWPARLQx7ke/DU=;
        b=alwxW//B3TUN4yCYJZjSliU+ptbxksyrNKhT0JsnR4aW7Tl1oDYMf+tZ8oWfiSWjZKa4vj
        6QNLqpjWFbWjj3TIz77V5Xdeb/yfh38RIgfbJF4Cb//BVXvSviW4ntVYoa+tg1sNEFng6L
        scIT6OQfmbB1sg1BTFU2IiYwnltQkXA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 410AF13524;
        Fri, 27 Oct 2023 16:19:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NX5eDBbjO2VENQAAMHmgww
        (envelope-from <ailiop@suse.com>); Fri, 27 Oct 2023 16:19:34 +0000
Date:   Fri, 27 Oct 2023 18:19:33 +0200
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, 1054644@bugs.debian.org
Cc:     Philip Hands <phil@hands.com>
Message-ID: <ZTvjFZPn7KH6euyT@technoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027154505.GL3195650@frogsfrogsfrogs>
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-4.97 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[3];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_NOT_FQDN(0.50)[];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         BAYES_HAM(-1.37)[90.67%]
X-Greylist: delayed 533 seconds by postgrey-1.36 at buxtehude; Fri, 27 Oct 2023 16:28:37 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2023 at 08:45:05AM -0700, Darrick J. Wong wrote:
> 
> mkfs.xfs in xfsprogs 6.5 turned on both the large extent counts and
> reverse mapping btree features by default.  My guess is that grub hasn't
> caught up with those changes to the ondisk format yet.
> 
> Ah, yeah, upstream grub hasn't picked up large extent counts (internally
> called nrext64) yet.
> https://git.savannah.gnu.org/cgit/grub.git/tree/grub-core/fs/xfs.c#n83

Yeap it is due to nrext64, I've submitted a patch to grub (should have
cc'ed linux-xfs..)

https://lore.kernel.org/grub-devel/20231026095339.31802-1-ailiop@suse.com/

Regards,
Anthony
