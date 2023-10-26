Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8727D8C25
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Oct 2023 01:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjJZXUO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Oct 2023 19:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjJZXUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2023 19:20:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BE2121;
        Thu, 26 Oct 2023 16:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kNKyr2vdFwrs0u1yAU9PrAKTZTudRp/eXEwLtaEij4A=; b=IavvdCuXlVtA5Zsx/UvnexXJUM
        +wLvkhfhlj3IyFP/gaRWMB8TwauDNFFJ1X1j+zIK/nhKK5yCUnxkvFUTEU6KrkYF7cEnSp0v6YfKP
        JDtYCin46KPUmF0I27CBuTgXP3ASxnxEudQxVNRd6hDPSpGq0+2EQafIkd35lTfdPeN7Xm+Qr3THk
        1MFOBOC264vUBIE4+daH8BFhuOUiODw1DzxwTI608W7FDK6qXibgYBIKPC/BnhnQUAdXG2Y+4fTex
        efJzOvgx48wwwPsHcyAOjNb8maFiinlLT0F6LPzDhTwHFEtTLaGzsFyWoTYzJbwRDUGAbJ4j07MVt
        Y3qC3eDw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qw9e5-00FJOt-0j;
        Thu, 26 Oct 2023 23:20:09 +0000
Date:   Thu, 26 Oct 2023 16:20:09 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Pankaj Raghav <kernel@pankajraghav.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        willy@infradead.org, djwong@kernel.org, hch@lst.de,
        da.gomez@samsung.com, gost.dev@samsung.com, david@fromorbit.com,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH] iomap: fix iomap_dio_zero() for fs bs > system page size
Message-ID: <ZTr0KZnrWdwrSUp/@bombadil.infradead.org>
References: <20231026140832.1089824-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026140832.1089824-1-kernel@pankajraghav.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2023 at 04:08:32PM +0200, Pankaj Raghav wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
> < fs block size. iomap_dio_zero() has an implicit assumption that fs block
> size < page_size. This is true for most filesystems at the moment.
> 
> If the block size > page size (Large block sizes)[1], this will send the
> contents of the page next to zero page(as len > PAGE_SIZE) to the
> underlying block device, causing FS corruption.
> 
> iomap is a generic infrastructure and it should not make any assumptions
> about the fs block size and the page size of the system.
> 
> Fixes: db074436f421 ("iomap: move the direct IO code into a separate file")

Nice!

> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> 
> [1] https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/

This URL jus tneeds to go above the Fixes tag.

   Luis
