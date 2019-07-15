Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65E069EF8
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 00:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfGOWeN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 18:34:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34718 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730473AbfGOWeN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 18:34:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so15327519wmd.1;
        Mon, 15 Jul 2019 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/YZE7NHZsHNyunauJoE3Bbdh+gYwzlr+8k6WrK75fmo=;
        b=mEx8LO7qVy7iUu4tY+kZvXx8JcHiHtU9lwBFjoqacYNdqONqoSqf5dRdmQEhz8qjOS
         8zPl0wzCiB9u/SQc7ArOJKHNZQIDc2qGIBh1R14V4j39xoNowVP90sS9lF/wria1s4Y8
         h0kbN+//kjKy4Ltv5R8QHlkaoSw6BX65/sJLIBBLXObwCSVvQDSjwgFbhHem/FRt4bjn
         fDLVb5pXuz2m4Gh43zz1AgcFcpCmvb44MP4neUnNew4JCi6KGn8a0Aq4UfYZ5h16wGb8
         +vIh10X3Wz/y+0GkoJP9CMP9OWl3aaa5B+rMEjBCDG9VCnWZOgfS+ORkzvtTGbWQcpya
         jI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/YZE7NHZsHNyunauJoE3Bbdh+gYwzlr+8k6WrK75fmo=;
        b=qe4SaO/64DW2ND8Dfw3vp5MsUOfGpcghpqA2d6MunY/yEPxgZ1MFhOINj/XRl0UIJK
         g6CifePHSbGizO1dHRixyYXlFeAJPfRktVJz9qaXoW3BWuNaZX80H7XrO+IQEZbTzhiN
         fqZc0Q6/9WV7+5/qulZGpsK+vRi+koCFRm5vvcthjcHgCxjPKt50A9WTJKBkCmavzW+f
         Fou1JzKTN+rlz83LDYBISyrE3766O2X1w0fO2YPUU+a5iaMkYSAfgYwz6psW+l4yUklq
         LstYdqP60fDsPFDfwaV708BYU0ujeu1nDull3dc9XWd/wYV7MUlMQOyp2gih/+1Z8d+5
         4RYg==
X-Gm-Message-State: APjAAAVPikb2VIzjOyido/Dh2j104tIyQLnmu/cSzM5lBj/eZEtoIW7I
        0O7GKe1WilFqCzDqEWuj0+M=
X-Google-Smtp-Source: APXvYqyanOOV2MgnuKwRbRl6PokkMJovJQTQqetqedVDBttm1naEnOaku70ankjm548zmFIOdFy8IQ==
X-Received: by 2002:a7b:c0c6:: with SMTP id s6mr27924332wmh.115.1563230051447;
        Mon, 15 Jul 2019 15:34:11 -0700 (PDT)
Received: from sheriff-Aspire-5735 ([129.205.112.210])
        by smtp.gmail.com with ESMTPSA id t140sm17349537wmt.0.2019.07.15.15.34.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jul 2019 15:34:10 -0700 (PDT)
Date:   Mon, 15 Jul 2019 23:34:05 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     skhan@linuxfoundation.org, linux-xfs@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v8] Documentation: filesystem: Convert xfs.txt to ReST
Message-ID: <20190715223404.GB27635@sheriff-Aspire-5735>
References: <20190714125831.GA19200@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714125831.GA19200@localhost>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 14, 2019 at 01:58:31PM +0100, Sheriff Esseson wrote:
>> Move xfs.txt to admin-guide, convert xfs.txt to ReST and broken references
>> 
>> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>

>Looks ok, will pull through the XFS tree.  Thanks for the submission!
>Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

>--D

Sorry, missed another table. Fix in v9.
