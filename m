Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D033521128
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 11:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiEJJmj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 05:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbiEJJmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:42:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21AE4754D
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Jx1qDqjYRKEr7LD5alogaevl92/nj/RmLUbk4lOtSaU=; b=gIlKlgWICgNZL9tAmTMl1C59Ls
        OrsZkYAXM/KrX2x/IhQfc2P3csktIvm+6mMnMNBTH/450AmcLoB2tkwMmdgDQqKmm8mN4Z9hwn4v6
        voXcSDplRQ0wZQuwvDWEWZDZL7l+vsXJtfDJgZP/iAkMEPEibzi7VuEe8ZxcOWchDGtwHE+9xkGPB
        PlSHAs7oWtR4v+54ikIteaPDCsXMHdApoEwFauT4k2qglf9g1IjXYHKnBF0dI5PLD7n4eOzFqOU8B
        /b8/rNHud1kYU0NfTRa/tvv2ATkuuKwwbt1TQSavVH1yU+7K6ZpDzxqNT6SmIDFfhe6cXVk6/JSBB
        uXch2KpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMK8-000t0g-5v; Tue, 10 May 2022 09:38:32 +0000
Date:   Tue, 10 May 2022 02:38:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: fix a complaint about a printf buffer overrun
Message-ID: <YnoymALWz6U/7geB@infradead.org>
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
 <165176665092.246897.6105158987030874479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176665092.246897.6105158987030874479.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 09:04:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> gcc 11 warns that stack_f doesn't allocate a sufficiently large buffer
> to hold the printf output.  I don't think the io cursor stack is really
> going to grow to 4 billion levels deep, but let's fix this anyway.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
