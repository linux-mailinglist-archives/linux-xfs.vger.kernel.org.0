Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EFF69EEE
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 00:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbfGOW1k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 18:27:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35993 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730641AbfGOW1k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 18:27:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so18786219wrs.3;
        Mon, 15 Jul 2019 15:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ECYx0jsV+D2Iazgclzflkc4muWvvwa0oB+OeJMfrxNw=;
        b=pwppsN3L9kuzdYqL/Hk8FrQ6wEyBCQEY+N90+P8znBQtI/XrQPru0xamWj8oEFR4c7
         4XjR14JFihsSVCnURiLAoOtyF4JeU6zoIL172W9E60jNFpTWmLcE+z/x1YT60oDxLplJ
         9hlPa0aRDsewD3T2DSVaoLNw7mkebLxC8sfJjOa56K+rGxdWT4kFD7azdAX33EoqdUc0
         tgmyuE6HzSL3TbPy3Mu1UlWr6VfCaWqoq+9uCT6aVyzyb6ppk8ah+Y1iwTWInO+rcswl
         9mcaGjVu/zL6bP0NpEQxlo/fum1IBvAtOX/YouIo6t3TVVz3C7bJ+ryooZhLysvRoAu/
         agWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ECYx0jsV+D2Iazgclzflkc4muWvvwa0oB+OeJMfrxNw=;
        b=DrGss6Tro6oGH/PZsxTZlKamTaLMspW0fzh2GyBs0Z5dVOnq65gJzrdzWAsH9a2JBB
         aeHpK73bSA7KKWqYE4UB6wm2MiQjsObz9UBP0G6xvKcYgs6ct0dP1z0tDQ4zAHsolFdu
         xlcKv9EznPL5jxCKKa0vaHlwosSViivxUX8Jf6Ys5zVvatBumd+ovO/GOLQ8/STa5rei
         /wPtGcR0WrhSUaIw0/kffgbqHrnJqOO2pPgwZtFtbmFte3SnmrT/C/9bwJTmY3MsJHHU
         w6AJ7OpdiMbGbvPq6Y0Tg5Vqmp8nBRZyzLl4ERvMQL/sZTN+iqg9GDot1jMv54GzicFK
         wqBw==
X-Gm-Message-State: APjAAAXzPcMJUvja0Z4jfkGxeythJtLjKgHdMuTzniHouxt+ZP+BwBfB
        /a4M3Atxq8eV2Yp0AKXHG1WBP01Y
X-Google-Smtp-Source: APXvYqwPZe9+pCh6pNbklAuTnU6e9FptAFF+GkM+NMQDd/uPpAFrwKjY712W6Rc6UWuXAyNPMPy4/w==
X-Received: by 2002:a5d:438e:: with SMTP id i14mr27907304wrq.122.1563229657629;
        Mon, 15 Jul 2019 15:27:37 -0700 (PDT)
Received: from sheriff-Aspire-5735 ([129.205.112.210])
        by smtp.gmail.com with ESMTPSA id z7sm15309691wrh.67.2019.07.15.15.27.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jul 2019 15:27:37 -0700 (PDT)
Date:   Mon, 15 Jul 2019 23:27:31 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     skhan@linuxfoundation.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v8] Documentation: filesystem: Convert xfs.txt to ReST
Message-ID: <20190715222727.GA27635@sheriff-Aspire-5735>
References: <20190714125831.GA19200@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714125831.GA19200@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 14, 2019 at 01:58:31PM +0100, Sheriff Esseson wrote:
> Move xfs.txt to admin-guide, convert xfs.txt to ReST and broken references
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>

>Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sorry, I missed something. Will fix in v9.
