Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225527E15D4
	for <lists+linux-xfs@lfdr.de>; Sun,  5 Nov 2023 19:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjKES2v (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 5 Nov 2023 13:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKES2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2023 13:28:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5DBDD
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 10:28:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 441961F37C;
        Sun,  5 Nov 2023 18:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1699208924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejMj5GEbSslglgjpg9+rlHBIGSGEJxOItOp3VwLhYLk=;
        b=NjCumtTcLT3kTEGY02LZilGvy6GpsJ0dDTgGpv8mgK1nGCro0P+pyX+ymO1DgqYHXOmMA6
        TuxlFqAaEMWBfiXwhhGEtByG4drBG2e+mcPe+kvJkRFzbzNt5k7hip0bxiBlepUaM9gf7C
        j0gzR8w1OOUlXLzztGmJmnBgoVoiTfc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F04B813907;
        Sun,  5 Nov 2023 18:28:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XVlYNtveR2UGLAAAMHmgww
        (envelope-from <ailiop@suse.com>); Sun, 05 Nov 2023 18:28:43 +0000
Date:   Sun, 5 Nov 2023 19:28:43 +0100
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: XFS_DEBUG got enabled by default in 6.6
Message-ID: <ZUfe2/nlLaJ20Ea8@technoir>
References: <308d32cc-4451-ad70-53bc-b41275023e45@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <308d32cc-4451-ad70-53bc-b41275023e45@applied-asynchrony.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 05, 2023 at 07:03:55PM +0100, Holger Hoffstätte wrote:
> Hello,
> 
> I recently updated to 6.6 and was surprised to see that XFS_DEBUG suddenly
> got enabled by default. This was apparently caused by commit d7a74cad8f45
> ("xfs: track usage statistics of online fsck") and a followup fix.

Actually the follow-up fix 57c0f4a8ea3a ("xfs: fix select in config
XFS_ONLINE_SCRUB_STATS") seems to be wrong, I think the original
intention was to select DEBUG_FS rather than XFS_DEBUG, since the
feature depends on debugfs to export those stats.

Regards,
Anthony
