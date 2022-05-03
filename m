Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B48D518780
	for <lists+linux-xfs@lfdr.de>; Tue,  3 May 2022 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiECO75 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 May 2022 10:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237549AbiECO7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 10:59:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7851396B8
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 07:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lvBl54UUOKHUSyd0s8jIPTkkweXCHMqoFQI84qCjIAU=; b=DyTV1fxt1DyK/mmtC/ZlpmeDGS
        PjLfZ12NcS5xi1w4U7GBUrbIRqThUlzRQBchIB93g03MzBDHk3ebbvvpuvyt9/G2M7Y4XjvqgmETP
        Kc0DkEm9XCkCUIGuIZGHqAZBC7cIWZgdmkd22b67OK0OOygrNWWdWpziTHcbf/8VijIUak0yEb0Yj
        9pfwkIoVY5c3utJd2cfqO0qzi6JaGMC7PXD6ZSLas3vig1oU1NyJNss+PAbF80gRVeWq/AeHqk1Ua
        dBfBhVONSyVwFBrLFREfL/VVjvGg01nOo7JHH0wJt3gSJnLP/4q3gevMVsseBzWJ5wPjEIRpIyPEu
        RQ5ZpyMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nltwq-006N1C-C2; Tue, 03 May 2022 14:56:20 +0000
Date:   Tue, 3 May 2022 07:56:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: set XFS_FEAT_NLINK correctly
Message-ID: <YnFClHs4dg17fhF+@infradead.org>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 02, 2022 at 06:20:17PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> While xfs_has_nlink() is not used in kernel, it is used in userspace
> (e.g. by xfs_db) so we need to set the XFS_FEAT_NLINK flag correctly
> in xfs_sb_version_to_features().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
