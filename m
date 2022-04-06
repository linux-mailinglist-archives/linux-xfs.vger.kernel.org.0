Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA7F4F68B5
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Apr 2022 20:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240021AbiDFSGM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Apr 2022 14:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239814AbiDFSGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:06:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91244BFFD
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=slo9BtY8MwL43QXVBcxLxHnCAuCtq0jM6jlQCXFjDdM=; b=DWywXFaEb54wqLy6GY/NRLTeub
        YuE2Q+xcob6/4Yltma0wkI+M26WpE5X3HAj3FIOGQhtTRaeeSawJj9gvs460Pk7NwnevJH9YUc1Ml
        J2GR9oj99bSs2C/mIo4Rgl4e4qlzgZlO6pjGefIEsaW/psQ/nAYXTQo+fvEXWwTmB1goNxrJwgiTm
        DcWAMTP9P2UR7Yt6kOrHzFewkVDg9Z/zD78xfUZ0w9Cp4PHbkpwRVUG6CSQOWwUvqy6AoRnB+J6OD
        nYJA/E4hOcE/MgccGspgjv9m714nxKHXeO9yeMztHxLRa0uYaFQ1DJDLuHzFFCJ6liClLF017zmT2
        D5oCZtbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8iA-007EQA-HB; Wed, 06 Apr 2022 16:40:50 +0000
Date:   Wed, 6 Apr 2022 09:40:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Subject: Re: [PATCH 4/6] xfs: always succeed at setting the reserve pool size
Message-ID: <Yk3CktbmAwYJ/xuf@infradead.org>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840031922.54920.3945394555613593655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840031922.54920.3945394555613593655.stgit@magnolia>
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

On Sun, Mar 27, 2022 at 09:58:39AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Nowadays, xfs_mod_fdblocks will always choose to fill the reserve pool
> with freed blocks before adding to fdblocks.  Therefore, we can change
> the behavior of xfs_reserve_blocks slightly -- setting the target size
> of the pool should always succeed, since a deficiency will eventually
> be made up as blocks get freed.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
