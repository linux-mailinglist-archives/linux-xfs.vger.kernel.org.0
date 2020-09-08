Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08167261E90
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Sep 2020 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbgIHTwt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Sep 2020 15:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730657AbgIHPsM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:48:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E750EC0A88C0
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iWXNQQVrPFaTXSc7qePZxsBPhnBiWDD1AuhzybawHmc=; b=NVlliKDthlKe4d59naMmnC7q/W
        xamenHUnBrEBw6BIfmHIh7/wz1tB/7TmmXfc/hOyTGR4gOjyA6Pg2UI80RdbATISQIlY7irA6RUBo
        wt0d3dhwOpqVNg4xQKrJuOGXYXsWllVSdyj2WP33gbTOiPtogPJdL2ISxounRu0MhoKd+BTwmd4m6
        dpK5ZfRlRbeTZHA38wXxUdC18OHour9kT2BlfYhAIeC+iUbsmHW4SlZ4JYhc3HHxXyFvHLufaNJG1
        7BOuKTj59PDIz5EnrVSBD5iJBrGcZfCC7+Mg5purmIoJGjap6WnooRXOBS/hn6r4rajnWo4ynl35b
        6+YzEJ9g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf5T-0003Gx-IR; Tue, 08 Sep 2020 14:59:13 +0000
Date:   Tue, 8 Sep 2020 15:59:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: ensure that fpunch, fcollapse, and finsert
 operations are aligned to rt extent size
Message-ID: <20200908145911.GN6039@infradead.org>
References: <159950166214.582172.6124562615225976168.stgit@magnolia>
 <159950168085.582172.4254559621934598919.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950168085.582172.4254559621934598919.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 11:01:20AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that any fallocate operation that requires the range to be
> block-aligned also checks that the range is aligned to the realtime
> extent size.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
