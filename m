Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA76728EE66
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgJOIXD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgJOIXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:23:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A08C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/ZIfAoxZh1J9tM0INwkzEER64GI8mbkcOijMwj+bU3Y=; b=mo+w6BrkM4NdYG8/pmuV6k0aDv
        u4s6A7Zr0GxIrdL3r3xONiMedGAjQr86OSmxe728M2tHavCJPhoGZgHaXqIQktTkOnaLOkIaIJ369
        Lfdj2zP0brJcx7MQCC0arVLjrbJXCpFtdKmlDGPsz+UONxaowOagO7oKvSgbQ8QhOcK1e/Jy5k62a
        xmHwzndK/SRZ+m3y6RI2844/HqcMrOo8eU4cDBDEekuAVhmyFoS+Gd0rg/zZZ2N/SzpHe6OMzNCqa
        vJaMZknmVwZ/nt8Ew5W9uQ24PN9qEE8Rhv20iLtT5nP4+dNLOgg8m4qXUjB7oU8WY8mwF4zoviTI5
        blj4XPmg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyX7-0000yk-QK; Thu, 15 Oct 2020 08:22:45 +0000
Date:   Thu, 15 Oct 2020 09:22:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v5 1/3] xfs: delete duplicated tp->t_dqinfo null check
 and allocation
Message-ID: <20201015082245.GA3583@infradead.org>
References: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
 <1602298461-32576-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602298461-32576-2-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 10, 2020 at 10:54:19AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The function xfs_trans_mod_dquot_byino() wrap around xfs_trans_mod_dquot()

s/wrap/wraps/

Also this line is too long for commit messages.

>
> to account for quotas, and also there is the function call chain
> xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv -> xfs_trans_mod_dquot,

This one as well.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
