Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3DE1C0F13
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 10:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgEAIAc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 04:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgEAIAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:00:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAD7C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=T3vZv6HEqDi3AN3BlOXszUkbzG0wrj8gRfIY8RA1aQQ=; b=dmnlseUHVArHWCQAGfbOSkS5O4
        ddAeLudGJPYwxgHDvHb0vJgaFQ2FYstZN160EGroSfy9AijmVuRdRZ3KICCvL19GJKinGpBqSbJ/l
        a3U0tRIL/GsbG0gR7hiPplpqBbQw1UgLdDwHr/made84MwOI2K8n1LXlsdaV7AtzZQdUAc40VKouR
        bLws9JdqYQXndkD+tYseXs5wLxRw0u1PoZj1cR6i+fkVU9+E+OMb9KL7XrnNeS90GHpQ6TKBOfAMZ
        tmj88iOYMahfRaXhciSpOp7wkdx2aV7JPiVYU4Ql0d+UMKsJxlR4V7i9lnS85dbhNEgwQZpujN7bD
        fHbpYalA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQb1-000428-N4; Fri, 01 May 2020 08:00:31 +0000
Date:   Fri, 1 May 2020 01:00:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 13/17] xfs: combine xfs_trans_ail_[remove|delete]()
Message-ID: <20200501080031.GH29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-14-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:49PM -0400, Brian Foster wrote:
>  /**
> - * Remove a log items from the AIL
> + * Remove a log item from the AIL.
>   *
> + * For each log item to be removed, unlink it from the AIL, clear the IN_AIL

This only works on one item, so the "For each" seems wrong.   That being
said I think we can just remove the comment entirely - the 'remove a log
item from the AIL' is pretty obvious from the name, and the details are
described in the helper actually implementing the functionality.

The rest looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
