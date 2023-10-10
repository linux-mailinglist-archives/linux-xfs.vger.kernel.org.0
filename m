Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26FA7BF3C0
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Oct 2023 09:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379424AbjJJHFf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Oct 2023 03:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442267AbjJJHFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 03:05:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D0299;
        Tue, 10 Oct 2023 00:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eHc5WzNz5xkDyMAX+lsBWgxGnx
        8HqjxyV8pRrykRvcU/QJ/akmFHrBNfgHFBsCj4nATwXaNEpJrvGrJ78ax5HtXL/s5c5grly6F76pO
        LOdaddEIpu2ZcZQoweXzKg0tcfP0lh8dWKzlaABLbEYD46+EvYDNp8tBYVGX8dCX4PR+SIKk+5n1N
        c+rVENc7foX/VgpBn8mlv+QSGi4wkXC6jaNBUE3pMad0/G5SpG6IBve92RpjRBQYV1vav97XTrNbD
        CtHJVkjDcEOLRH9UjBo1Jb9aR/ldW6Fm+7ct42L2fVqZFHLZ/5yvTWNk+pUpWJP/+SZJ/j2Ul7NK8
        dvT92lKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq6o7-00CfbA-1m;
        Tue, 10 Oct 2023 07:05:31 +0000
Date:   Tue, 10 Oct 2023 00:05:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        willy@infradead.org
Subject: Re: [PATCH 1/1] generic: test FALLOC_FL_UNSHARE when pagecache is
 not loaded
Message-ID: <ZST3u3AJvOekLOb5@infradead.org>
References: <169687553806.3949152.10461541168914314461.stgit@frogsfrogsfrogs>
 <169687554366.3949152.2864477369744294080.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169687554366.3949152.2864477369744294080.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
