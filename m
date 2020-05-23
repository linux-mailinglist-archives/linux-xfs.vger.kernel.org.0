Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478101DF61F
	for <lists+linux-xfs@lfdr.de>; Sat, 23 May 2020 10:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbgEWIuW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 May 2020 04:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387471AbgEWIuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 04:50:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8E8C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 01:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=rhCZ7pdFPeQyZvAVNg+O310ZLM
        CKRqY0uNtbKyjmFC6Eprr6xB0Cb7137R5BFwyOpcEt1AuZufZ4anfpJGxWysDvCEUMVW72Y1Oms0j
        +XrJvER7qx/doqmUWY+lp+ldQDHee8OG2bTGPzKRzzNcv8H4txK7t5IJ/uEBFZVo0EqEun2/1SR6E
        PCuSq3/Xypcx51sMxkuxKN4ILp/a33WqZkpWJlnKImhfnQB5aidvXqhcWqc8j1KlDSOFypxpI7IK+
        TDTe7a/nl15uNS0NmuorbcJXRi4Vutbjq+jzn/ggnoaJ1RcYn7lzOYka4+bnmBYWek99CPsTJDGHc
        Emp+QUqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcPrJ-0003Qd-Lm; Sat, 23 May 2020 08:50:21 +0000
Date:   Sat, 23 May 2020 01:50:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/24] xfs: clean up whacky buffer log item list reinit
Message-ID: <20200523085021.GC31566@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
