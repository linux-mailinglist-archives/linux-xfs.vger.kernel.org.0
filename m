Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABE554DBD9
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jun 2022 09:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359470AbiFPHek (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jun 2022 03:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359475AbiFPHek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:34:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F132D2AF8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K55oIf/F1kWjV4RMkt9iosw7Tu0Fjsgyu2HoNzCXp9s=; b=wgIFeCbQdJNZYT4ckE0gFcpjMp
        yMHrY+7UsPWkIVEAEpFzAOiONEaaVVL5apCHYuM4oz9E5YDGEtLeHvuX+1m65n4ia7nVLzhZD/DB4
        lDSXKdNndDlCHMYzfHW28OmDvrOCtNVTor+5M5i4KWJvfvE2YycTaPtyp4EgaGmGaZpU3y35zayaw
        okqnHkJ+r/7HBTpNZd6wANNvuiKlpy5zAm5cQkRabEkhLEuojrUGv4SwB7zwmbbWX5mt055T7QR03
        KeVKONRudMYzkuhmHhOcT+opWPaRDkj2x0xuxoL99B/NhdhQrr/2tBAGbYxsfPOpn2KHid3mcKMud
        kC8YmAhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1k1W-00150x-Km; Thu, 16 Jun 2022 07:34:38 +0000
Date:   Thu, 16 Jun 2022 00:34:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/50] xfs: pass perag to xfs_ialloc_read_agi()
Message-ID: <YqrdDl7Rr3qQQ4NM@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 11:26:12AM +1000, Dave Chinner wrote:
> @@ -833,7 +835,7 @@ xfs_ag_shrink_space(
>  		xfs_trans_bhold(*tpp, agfbp);
>  		err2 = xfs_trans_roll(tpp);
>  		if (err2)
> -			return err2;
> +			return error;
>  		xfs_trans_bjoin(*tpp, agfbp);
>  		goto resv_init_out;
>  	}

This change looks unrelated and is undocumented.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
