Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2F768EBF
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Jul 2023 09:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjGaHaU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Jul 2023 03:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjGaHaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2023 03:30:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290025270
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 00:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UY9yKVE3sFjkDMGj7GuHAb/e9J0/DSLlY2K41ijY1/c=; b=CaO9gVBqXGJGA7AlxxpBH4IYlK
        jrCmAepsirzSrj2VHeAAgZhHxfA86xgQImqRTBeT643eVGhvwLVZpC66+WxMTsuCCYJIeLNZQQRMZ
        Sc2sCFU7wBCJpjzKOvrb5AMx7U8V3jijep3s6g/hqZHrJNSnqhwWvIT8MtunaPKAwuHUJvLwMufbV
        XvEj9ptoa2EpgDk2pmXvmXrBirnrO2RuWugw4ii2jsXXmp2srZFOtq8yIiPedNondDFIQLdMp8HZX
        /4Tss5zQwEJ0Rh+JluzTqiGUTXlJYWpD5JBmCxSGW9FJo+rFhb/q0olXTZr575qkbz0cYRtHr+QQE
        XITQTLPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qQNJF-00EJVB-0w;
        Mon, 31 Jul 2023 07:27:17 +0000
Date:   Mon, 31 Jul 2023 00:27:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Shawn <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: how does XFS support gpu direct storage
Message-ID: <ZMdiVS5eo0gKDbw9@infradead.org>
References: <CAB-bdyTUFfLw2O80h67WGkok1hM0PKrsjCR_wdMzALQWqi6rrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyTUFfLw2O80h67WGkok1hM0PKrsjCR_wdMzALQWqi6rrA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 30, 2023 at 02:20:17PM -0700, Shawn wrote:
> Hello all,
> Nvidia document explains that,  in order for a filesystem to support
> GDS (gpu direct storage) the FS needs to make a callback to
> "nvidis-fs.ko"  to translate a virtual address to GPU physical address
> for DMA.   However I'm unable to find the callback in XFS code.  I'm
> curious how can XFS support GDS without calling nvidia callbacks?

nidia needs to f**king stop violating our copyrights and just go away.

