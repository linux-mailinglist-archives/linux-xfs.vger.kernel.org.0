Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933BA81960
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 14:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbfHEMfA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Aug 2019 08:35:00 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45408 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfHEMfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 08:35:00 -0400
Received: by mail-oi1-f194.google.com with SMTP id m206so61899916oib.12
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 05:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9PD99q1WDdgGS5wXWSODQaMo35MVtofLkqVSDDdXLQ=;
        b=W8R+F2A+P76XrIGtfZAsVKskoJxi6QCvKAFJ1JmTwp1xA0G/BPFf1dYKeJwPe5vaP7
         Dtbng6LCIg1R5vxPhNSpF/qqj2Rb6Gb9wyIT2L5idmxVOVJsz03kfcd97d2qDRzHetuU
         by603gWSN/oGoiqFaQy4daq32e3ytjLVNgfbO5BqpJRj7EsGrOlgZwck5fcHkVLxhJh/
         bSeENVWWQuHZ4r8m54DkXaNdYp5M9KpDLVE6opkfcnynBqzDAxjYuhhhrTv4XLdDK3Zi
         ERRVD+lgfNRVIccap58XZymRfMI3lNK2WXRqb3GqibLLU0ZgGTVwxhfAfDHfJvUi3pCF
         AG7A==
X-Gm-Message-State: APjAAAXFQzcwOyal6ygQI5zoBx5bddz6lyXsSMrA3+/RIgmCAvJvQHQV
        0qBJzXUm8nJ7GWCAKskSEwIrvfJm417UWTupsUrggc2M
X-Google-Smtp-Source: APXvYqx6OeLbcsQmv8sCdKHaXgIbC/F381FJwA38avKdMNNekpIY2ey+NNhV8ycrBsZ4I6P1pLKNKMDH+hgN2NkPuUQ=
X-Received: by 2002:aca:f08a:: with SMTP id o132mr10795741oih.101.1565008499934;
 Mon, 05 Aug 2019 05:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <156444945993.2682261.3926017251626679029.stgit@magnolia> <20190730144839.GA17025@infradead.org>
In-Reply-To: <20190730144839.GA17025@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 5 Aug 2019 14:34:49 +0200
Message-ID: <CAHc6FU6MX=QgNKU9MOV6z0QB0gcExB26sFKQVyjzvbGJfdC=5Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] iomap: lift the xfs writepage code into iomap
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 30 Jul 2019 at 16:48, Christoph Hellwig <hch@infradead.org> wrote:
> I don't really see the point of the split, but the result looks fine
> to me.

The split made it easier for me to debug the gfs2 side by backing out
the xfs changes.

Thanks,
Andreas
