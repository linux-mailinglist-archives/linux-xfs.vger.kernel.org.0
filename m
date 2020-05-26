Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0422F1B881D
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Apr 2020 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgDYRaJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 25 Apr 2020 13:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:30:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465E8C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IWfzw8L2373juQ77HsLyL2omDfpHdUWzmaK9dH8u3kI=; b=M2tW12D3sOm4EdD4zNP2ZzqeVG
        qZ1NZ6J/N4FQC8QXlox5hhK11TF0csEyuN9srT1QeT4rO6n+yFSxbXYESKrXZoPfhGvbrqLuSkJxp
        2PHAaAIVCmCpJT3HHHdfnJOcUVSR31AJ6feuVOMz4zZ57um4n1LZPjDmOojT9/gXMihLTef/GehEy
        cVTQYHaJfU8I7YA6kAuSMud4P3hyyRTsb9MMk1xBqtew+ifstpILrQwd8x1oDBYIOKAr8DGAGHzLg
        tZ4tPPRb5OnPiM12mBGuBihyNOa7h2tF+xqdeCgIqhz+LuYXwWUSmschJO0QOF5otrbfoTTzPvMxi
        k/959wXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOcz-0007sI-4H; Sat, 25 Apr 2020 17:30:09 +0000
Date:   Sat, 25 Apr 2020 10:30:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 07/13] xfs: abort consistently on dquot flush failure
Message-ID: <20200425173009.GF30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-8-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:23PM -0400, Brian Foster wrote:
> The dquot flush handler effectively aborts the dquot flush if the
> filesystem is already shut down, but doesn't actually shut down if
> the flush fails. Update xfs_qm_dqflush() to consistently abort the
> dquot flush and shutdown the fs if the flush fails with an
> unexpected error.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
